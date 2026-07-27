import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../api/api_service.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';

const _categories = [
  'Pumps', 'Compressors', 'Pipelines', 'Tanks', 'Motors', 'Valves',
  'Electrical Panels', 'Generators', 'Transformers', 'Wellheads', 'Other',
];

class AssetFormScreen extends StatefulWidget {
  const AssetFormScreen({this.assetId, super.key});
  final String? assetId;

  @override
  State<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final name = TextEditingController();
  final tag = TextEditingController();
  final manufacturer = TextEditingController();
  final model = TextEditingController();
  final serial = TextEditingController();
  final description = TextEditingController();
  final lat = TextEditingController();
  final lng = TextEditingController();
  List<FacilityDetail> facilities = const [];
  List<AreaDetail> areas = const [];
  String? facilityId;
  String? areaId;
  String category = _categories.first;
  String status = 'Healthy';
  bool loading = true;
  bool saving = false;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loading) _load();
  }

  Future<void> _load() async {
    final api = AuthProvider.of(context).api;
    try {
      final results = await Future.wait([api.getFacilities(limit: 100), api.getAreas(limit: 100)]);
      facilities = (results[0] as FacilityListPage).items.toList();
      areas = (results[1] as AreaListPage).items.toList();
      if (widget.assetId != null) {
        final asset = await api.getAsset(widget.assetId!);
        name.text = asset.name; tag.text = asset.assetTag;
        manufacturer.text = asset.manufacturer ?? ''; model.text = asset.model ?? '';
        serial.text = asset.serialNumber ?? ''; description.text = asset.description ?? '';
        lat.text = asset.gpsLat?.toString() ?? ''; lng.text = asset.gpsLng?.toString() ?? '';
        facilityId = asset.facilityId; areaId = asset.areaId; category = asset.category;
        status = asset.currentStatus.name;
      }
    } catch (_) {
      error = 'Could not load the asset form.';
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _save() async {
    if (name.text.trim().length < 2 || tag.text.trim().isEmpty || facilityId == null) {
      setState(() => error = 'Name, asset tag, and facility are required.');
      return;
    }
    final latitude = lat.text.isEmpty ? null : num.tryParse(lat.text);
    final longitude = lng.text.isEmpty ? null : num.tryParse(lng.text);
    if ((latitude == null) != (longitude == null) ||
        (latitude != null && (latitude < -90 || latitude > 90)) ||
        (longitude != null && (longitude < -180 || longitude > 180))) {
      setState(() => error = 'Enter valid latitude and longitude together.');
      return;
    }
    setState(() { saving = true; error = null; });
    final api = AuthProvider.of(context).api;
    try {
      late AssetDetail saved;
      if (widget.assetId == null) {
        saved = await api.createAsset(CreateAssetRequest((b) => b
          ..name = name.text.trim()
          ..assetTag = tag.text.trim()
          ..facilityId = facilityId!
          ..areaId = areaId
          ..category = category
          ..manufacturer = manufacturer.text.isEmpty ? null : manufacturer.text
          ..model = model.text.isEmpty ? null : model.text
          ..serialNumber = serial.text.isEmpty ? null : serial.text
          ..description = description.text.isEmpty ? null : description.text
          ..gpsLat = latitude
          ..gpsLng = longitude
          ..currentStatus = CreateAssetRequestCurrentStatusEnum.valueOf(status)));
      } else {
        saved = await api.updateAsset(widget.assetId!, UpdateAssetRequest((b) => b
          ..name = name.text.trim()
          ..assetTag = tag.text.trim()
          ..facilityId = facilityId
          ..areaId = areaId
          ..category = category
          ..manufacturer = manufacturer.text.isEmpty ? null : manufacturer.text
          ..model = model.text.isEmpty ? null : model.text
          ..serialNumber = serial.text.isEmpty ? null : serial.text
          ..description = description.text.isEmpty ? null : description.text
          ..gpsLat = latitude
          ..gpsLng = longitude
          ..currentStatus = UpdateAssetRequestCurrentStatusEnum.valueOf(status)));
      }
      if (mounted) Navigator.of(context).pop(saved.id);
    } catch (_) {
      if (mounted) setState(() => error = 'Could not save the asset.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [name, tag, manufacturer, model, serial, description, lat, lng]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    final matchingAreas = areas.where((area) => area.facilityId == facilityId).toList();
    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        Text(widget.assetId == null ? 'Create asset' : 'Edit asset', style: Theme.of(context).textTheme.headlineMedium),
        if (error != null) Padding(padding: const EdgeInsets.only(top: DsSpacing.s3), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        const SizedBox(height: DsSpacing.s4),
        AppCard(child: Column(children: [
          AppTextField(label: 'Name', controller: name),
          const SizedBox(height: DsSpacing.s3),
          AppTextField(label: 'Asset tag', controller: tag),
          const SizedBox(height: DsSpacing.s3),
          AppSelect<String>(label: 'Category', items: [for (final value in _categories) DropdownMenuItem(value: value, child: Text(value))], onChanged: (value) => setState(() => category = value!), value: category),
          const SizedBox(height: DsSpacing.s3),
          AppSelect<String>(label: 'Status', items: [for (final value in ['Healthy', 'Warning', 'Critical']) DropdownMenuItem(value: value, child: Text(value))], onChanged: (value) => setState(() => status = value!), value: status),
        ])),
        const SizedBox(height: DsSpacing.s4),
        AppCard(child: Column(children: [
          AppTextField(label: 'Manufacturer', controller: manufacturer),
          const SizedBox(height: DsSpacing.s3), AppTextField(label: 'Model', controller: model),
          const SizedBox(height: DsSpacing.s3), AppTextField(label: 'Serial number', controller: serial),
          const SizedBox(height: DsSpacing.s3), AppTextField(label: 'Description', controller: description, maxLines: 4),
        ])),
        const SizedBox(height: DsSpacing.s4),
        AppCard(child: Column(children: [
          AppSelect<String>(label: 'Facility', items: [for (final item in facilities) DropdownMenuItem(value: item.id, child: Text(item.name))], onChanged: (value) => setState(() { facilityId = value; areaId = null; }), value: facilityId),
          const SizedBox(height: DsSpacing.s3),
          AppSelect<String?>(label: 'Area (optional)', items: [const DropdownMenuItem(value: null, child: Text('No area')), for (final item in matchingAreas) DropdownMenuItem(value: item.id, child: Text(item.name))], onChanged: (value) => setState(() => areaId = value), value: areaId),
          const SizedBox(height: DsSpacing.s3), AppTextField(label: 'GPS latitude', controller: lat, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true)),
          const SizedBox(height: DsSpacing.s3), AppTextField(label: 'GPS longitude', controller: lng, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true)),
        ])),
        const SizedBox(height: DsSpacing.s5),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          AppButton(label: 'Cancel', onPressed: () => Navigator.of(context).maybePop(), variant: AppButtonVariant.ghost),
          const SizedBox(width: DsSpacing.s3),
          AppButton(label: widget.assetId == null ? 'Create asset' : 'Save changes', loading: saving, onPressed: saving ? null : _save),
        ]),
      ],
    );
  }
}
