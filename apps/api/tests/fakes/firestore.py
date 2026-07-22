from collections.abc import AsyncIterator
from copy import deepcopy
from typing import Any


class FakeDocumentSnapshot:
    def __init__(self, document_id: str, data: dict[str, Any] | None) -> None:
        self.id = document_id
        self.exists = data is not None
        self._data = deepcopy(data)

    def to_dict(self) -> dict[str, Any] | None:
        return deepcopy(self._data)


class FakeDocumentReference:
    def __init__(self, client: "FakeAsyncClient", collection: str, document_id: str) -> None:
        self._client = client
        self._collection = collection
        self.id = document_id

    async def get(self, **_: Any) -> FakeDocumentSnapshot:
        data = self._client._store.get(self._collection, {}).get(self.id)
        return FakeDocumentSnapshot(self.id, data)

    async def set(self, data: dict[str, Any], **_: Any) -> None:
        self._client._store.setdefault(self._collection, {})[self.id] = deepcopy(data)

    async def delete(self, **_: Any) -> None:
        self._client._store.setdefault(self._collection, {}).pop(self.id, None)


class FakeQuery:
    def __init__(
        self,
        client: "FakeAsyncClient",
        collection: str,
        filters: tuple[tuple[str, str, Any], ...] = (),
        order_by_field: str | None = None,
        order_by_descending: bool = False,
    ) -> None:
        self._client = client
        self._collection = collection
        self._filters = filters
        self._order_by_field = order_by_field
        self._order_by_descending = order_by_descending

    def where(self, *, filter: Any) -> "FakeQuery":
        return FakeQuery(
            self._client,
            self._collection,
            self._filters + ((filter.field_path, filter.op_string, filter.value),),
            self._order_by_field,
            self._order_by_descending,
        )

    def order_by(self, field_path: str, *, direction: str = "ASCENDING") -> "FakeQuery":
        return FakeQuery(
            self._client,
            self._collection,
            self._filters,
            field_path,
            direction == "DESCENDING",
        )

    async def stream(self, **_: Any) -> AsyncIterator[FakeDocumentSnapshot]:
        items = sorted(self._client._store.get(self._collection, {}).items())
        if self._order_by_field is not None:
            field = self._order_by_field
            items.sort(
                key=lambda item: (item[1].get(field), item[0]),
                reverse=self._order_by_descending,
            )
        for document_id, data in items:
            if all(
                (operator == "==" and data.get(field) == value)
                or (operator == ">=" and data.get(field) is not None and data.get(field) >= value)
                or (operator == "<=" and data.get(field) is not None and data.get(field) <= value)
                for field, operator, value in self._filters
            ):
                yield FakeDocumentSnapshot(document_id, data)


class FakeCollectionReference(FakeQuery):
    def document(self, document_id: str) -> FakeDocumentReference:
        return FakeDocumentReference(self._client, self._collection, document_id)


class FakeAsyncClient:
    def __init__(self) -> None:
        self._store: dict[str, dict[str, dict[str, Any]]] = {}

    def collection(self, collection: str) -> FakeCollectionReference:
        return FakeCollectionReference(self, collection)

    def documents(self, collection: str) -> dict[str, dict[str, Any]]:
        return deepcopy(self._store.get(collection, {}))

    def counts(self) -> dict[str, int]:
        return {collection: len(documents) for collection, documents in sorted(self._store.items())}
