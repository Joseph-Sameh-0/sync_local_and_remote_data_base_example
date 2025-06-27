class WriteOperation {
  final WriteOperationType type;
  final String path;
  final Map<String, dynamic>? data;
  final bool merge;

  WriteOperation.set(this.path, this.data, {this.merge = false})
      : type = WriteOperationType.set;

  WriteOperation.update(this.path, this.data)
      : type = WriteOperationType.update,
        merge = false;

  WriteOperation.delete(this.path)
      : type = WriteOperationType.delete,
        data = null,
        merge = false;
}

enum WriteOperationType { set, update, delete }
