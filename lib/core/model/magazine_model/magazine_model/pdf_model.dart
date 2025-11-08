class PdfModel {
  String? issueNumber;
  String? pdfUrl;
  String? thumbnailUrl;
  String? createdAt;

  PdfModel({this.issueNumber, this.pdfUrl, this.thumbnailUrl, this.createdAt});

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
    issueNumber: json['issueNumber'] as String?,
    pdfUrl: json['pdfUrl'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'issueNumber': issueNumber,
    'pdfUrl': pdfUrl,
    'thumbnailUrl': thumbnailUrl,
    'createdAt': createdAt,
  };
}
