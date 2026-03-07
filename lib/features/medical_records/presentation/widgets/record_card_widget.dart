import 'package:flutter/material.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

class RecordCardWidget extends StatelessWidget {
  final MedicalRecordEntity record;
  final VoidCallback? onTap;

  const RecordCardWidget({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          record.type == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
          color: Colors.blueGrey,
        ),
        title: Text(record.title),
        subtitle: Text(
          record.createdAt.toLocal().toString().split(' ')[0],
        ),
      ),
    );
  }
}
