from fastapi import FastAPI

app = FastAPI(title="FEV API", version="0.2.0")


@app.get("/")
async def root() -> dict[str, str]:
    return {"service": "fev-api", "status": "ok"}
