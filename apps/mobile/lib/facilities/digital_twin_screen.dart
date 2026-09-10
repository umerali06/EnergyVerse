import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../auth/auth_controller.dart';
import '../design_system/tokens_generated.dart';

class _HotspotData {
  _HotspotData({
    required this.id,
    required this.assetId,
    required this.assetTag,
    required this.assetName,
    required this.status,
    required this.position,
    required this.raw,
  });

  factory _HotspotData.fromMap(Map<String, dynamic> map) {
    final rawStatus = (map['current_status'] ?? map['status'] ?? 'Healthy').toString().trim();
    final statusStr = rawStatus.isEmpty
        ? 'Healthy'
        : rawStatus[0].toUpperCase() + rawStatus.substring(1).toLowerCase();

    final rawPos = map['position'];
    final posList = <double>[0.0, 0.0, 0.0];
    if (rawPos is List && rawPos.isNotEmpty) {
      for (var i = 0; i < rawPos.length && i < 3; i++) {
        final val = rawPos[i];
        if (val is num) posList[i] = val.toDouble();
      }
    }

    final tag = (map['asset_tag'] ?? map['tag'] ?? map['asset_id'] ?? map['id'] ?? 'ASSET').toString();
    final name = (map['asset_name'] ?? map['name'] ?? tag).toString();
    final id = (map['id'] ?? map['asset_id'] ?? tag).toString();

    return _HotspotData(
      id: id,
      assetId: (map['asset_id'] ?? id).toString(),
      assetTag: tag,
      assetName: name,
      status: statusStr,
      position: posList,
      raw: map,
    );
  }

  final String id;
  final String assetId;
  final String assetTag;
  final String assetName;
  final String status;
  final List<double> position;
  final Map<String, dynamic> raw;

  Color get statusColor => switch (status.toLowerCase()) {
        'healthy' => DsColors.statusSuccess,
        'warning' => DsColors.statusWarning,
        'critical' => DsColors.statusCritical,
        _ => DsColors.primary400,
      };
}

class DigitalTwinScreen extends StatefulWidget {
  const DigitalTwinScreen({super.key, this.api});

  final ApiContract? api;

  @override
  State<DigitalTwinScreen> createState() => _DigitalTwinScreenState();
}

class _DigitalTwinScreenState extends State<DigitalTwinScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, String>> _facilities = [];
  String _selectedFacilityId = '';
  Map<String, dynamic>? _scene;

  String _statusFilter = 'All';
  String _activePresetId = 'cam_overhead';
  _HotspotData? _selectedHotspot;

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      final api = widget.api ?? AuthProvider.of(context).api;
      final res = await api.getFacilities(limit: 50);
      final items = res.items.toList();
      final list = items.map((f) => {'id': f.id, 'name': f.name}).toList();

      if (mounted) {
        setState(() {
          _facilities = list;
          if (list.isNotEmpty) {
            _selectedFacilityId = list.first['id']!;
          }
          _loading = false;
        });
        if (_selectedFacilityId.isNotEmpty) {
          _loadScene(_selectedFacilityId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Unable to load facility list for 3D Digital Twin';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadScene(String facilityId) async {
    try {
      setState(() {
        _loading = true;
        _error = null;
        _selectedHotspot = null;
      });

      final facName = _facilities.firstWhere(
            (f) => f['id'] == facilityId,
            orElse: () => {'name': 'Compressor Station 2'},
          )['name'] ??
          'Compressor Station 2';

      final mockScene = {
        'facility_id': facilityId,
        'facility_name': facName,
        'scene_type': 'procedural_refinery',
        'camera_presets': [
          {
            'id': 'cam_overhead',
            'name': 'Overhead Overview',
            'position': [0, 50, 60],
            'target': [0, 0, 0]
          },
          {
            'id': 'cam_pumps',
            'name': 'Pump Skid Station',
            'position': [-15, 12, 20],
            'target': [-12, 0, 8]
          },
          {
            'id': 'cam_tanks',
            'name': 'Tank Farm Area',
            'position': [20, 18, 25],
            'target': [18, 0, -10]
          },
        ],
        'hotspots': [
          {
            'id': 'node-1',
            'asset_id': 'asset-101',
            'asset_tag': 'P-101A',
            'asset_name': 'Main Crude Charge Pump',
            'category': 'Pump',
            'current_status': 'Healthy',
            'position': [-12.0, 2.0, 8.0]
          },
          {
            'id': 'node-2',
            'asset_id': 'asset-102',
            'asset_tag': 'C-201',
            'asset_name': 'Gas Compressor Unit 1',
            'category': 'Compressor',
            'current_status': 'Warning',
            'position': [0.0, 4.0, -5.0]
          },
          {
            'id': 'node-3',
            'asset_id': 'asset-103',
            'asset_tag': 'TK-301',
            'asset_name': 'Heavy Naphtha Storage Tank',
            'category': 'Tank',
            'current_status': 'Critical',
            'position': [18.0, 6.0, -10.0]
          },
        ],
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (mounted) {
        setState(() {
          _scene = mockScene;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Unable to load 3D Spatial Scene';
          _loading = false;
        });
      }
    }
  }

  List<_HotspotData> get _filteredHotspots {
    if (_scene == null || _scene!['hotspots'] == null) return [];
    final rawList = _scene!['hotspots'];
    if (rawList is! List) return [];
    final parsed = rawList
        .whereType<Map>()
        .map((h) => _HotspotData.fromMap(Map<String, dynamic>.from(h)))
        .toList();
    if (_statusFilter == 'All') return parsed;
    return parsed
        .where((h) => h.status.toLowerCase() == _statusFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Digital Twin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFacilities,
            tooltip: 'Refresh Scene',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header & Facility Selector
          Container(
            padding: const EdgeInsets.all(16.0),
            color: DsColors.darkSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _scene?['facility_name'] ?? 'Facility Twin',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '3D Spatial Visualization • Field Digital Twin',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: DsColors.darkTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_facilities.isNotEmpty)
                      DropdownButton<String>(
                        value: _selectedFacilityId.isNotEmpty
                            ? _selectedFacilityId
                            : _facilities.first['id'],
                        dropdownColor: DsColors.darkSurface,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: const SizedBox(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedFacilityId = val);
                            _loadScene(val);
                          }
                        },
                        items: _facilities.map((f) {
                          return DropdownMenuItem<String>(
                            value: f['id'],
                            child: Text(f['name'] ?? ''),
                          );
                        }).toList(),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Camera Presets
                if (_scene != null && _scene!['camera_presets'] is List)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: (_scene!['camera_presets'] as List<dynamic>)
                          .whereType<Map>()
                          .map((preset) {
                        final id = (preset['id'] ?? '').toString();
                        final name = (preset['name'] ?? id).toString();
                        final isActive = _activePresetId == id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(name),
                            selected: isActive,
                            selectedColor: DsColors.primary600,
                            labelStyle: TextStyle(
                              color: isActive ? Colors.white : DsColors.darkTextSecondary,
                              fontSize: 12,
                            ),
                            onSelected: (_) {
                              setState(() => _activePresetId = id);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 8),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Healthy', 'Warning', 'Critical'].map((status) {
                      final isActive = _statusFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(status),
                          selected: isActive,
                          selectedColor: DsColors.darkElevated,
                          labelStyle: TextStyle(
                            color: isActive ? Colors.white : DsColors.darkTextMuted,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            setState(() => _statusFilter = status);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main Viewport Canvas Area
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.amber),
                            const SizedBox(height: 16),
                            Text(_error!, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadFacilities,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: DsColors.darkBackground,
                        child: Stack(
                          children: [
                            // 3D/Spatial Grid Viewport
                            Center(
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: _SpatialGridPainter(),
                              ),
                            ),

                            // Asset Nodes Over Grid
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final hotspots = _filteredHotspots;
                                return Stack(
                                  children: hotspots.map((hotspot) {
                                    final pos = hotspot.position;
                                    final tag = hotspot.assetTag;
                                    final isSelected = _selectedHotspot?.id == hotspot.id;
                                    final statusColor = hotspot.statusColor;

                                    final centerX = constraints.maxWidth / 2;
                                    final centerY = constraints.maxHeight / 2;
                                    final xPct = (pos[0] / 30.0).clamp(-0.85, 0.85);
                                    final yPct = (pos[2] / 30.0).clamp(-0.85, 0.85);

                                    final nodeLeft = centerX + (xPct * (constraints.maxWidth / 2.2));
                                    final nodeTop = centerY + (yPct * (constraints.maxHeight / 2.2));

                                    return Positioned(
                                      left: nodeLeft - 45,
                                      top: nodeTop - 20,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => _selectedHotspot = hotspot);
                                          _showAssetBottomSheet(context, hotspot);
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? DsColors.darkSurface
                                                : DsColors.darkSurface.withValues(alpha: 0.85),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white
                                                  : statusColor.withValues(alpha: 0.8),
                                              width: isSelected ? 2.0 : 1.2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: statusColor.withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: statusColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                tag,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: DsTypography.mono,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                            // Footer Indicator Legend
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: DsColors.darkSurface.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: DsColors.darkBorder),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _LegendDot(color: DsColors.statusSuccess, label: 'Healthy'),
                                    SizedBox(width: 12),
                                    _LegendDot(color: DsColors.statusWarning, label: 'Warning'),
                                    SizedBox(width: 12),
                                    _LegendDot(color: DsColors.statusCritical, label: 'Critical'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showAssetBottomSheet(BuildContext context, _HotspotData hotspot) {
    final name = hotspot.assetName;
    final tag = hotspot.assetTag;
    final status = hotspot.status;
    final pos = hotspot.position;
    final statusColor = hotspot.statusColor;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DsColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: const TextStyle(
                          color: DsColors.primary400,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: DsTypography.mono,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(status),
                    backgroundColor: statusColor.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DsColors.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: DsColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3D Spatial Coordinates',
                      style: TextStyle(color: DsColors.darkTextMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('X: ${pos[0]}m',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: DsTypography.mono)),
                        Text('Y: ${pos[1]}m',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: DsTypography.mono)),
                        Text('Z: ${pos[2]}m',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: DsTypography.mono)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Asset Details'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/assets');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: DsColors.darkTextSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _SpatialGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DsColors.darkBorder.withValues(alpha: 0.4)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final axisPaint = Paint()
      ..color = DsColors.primary500.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), axisPaint);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
