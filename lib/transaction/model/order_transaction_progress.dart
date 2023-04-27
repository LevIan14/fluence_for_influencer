import 'package:fluence_for_influencer/transaction/model/progress/content_progress.dart';
import 'package:fluence_for_influencer/transaction/model/progress/review_content.dart';
import 'package:fluence_for_influencer/transaction/model/progress/review_upload.dart';
import 'package:fluence_for_influencer/transaction/model/progress/upload_progress.dart';

class OrderTransactionProgress {
  final ContentProgress contentProgress;
  final ReviewContent reviewContent;
  final UploadProgress uploadProgress;
  final ReviewUpload reviewUpload;

  OrderTransactionProgress(this.contentProgress, this.reviewContent,
      this.uploadProgress, this.reviewUpload);
}
