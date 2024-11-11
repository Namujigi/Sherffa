// // lib/src/audio_recorder.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';

// class AudioRecorder {
//   // 오디오 녹음을 위한 Record 인스턴스
//   final _audioRecorder = Record();
//   // HTTP 통신을 위한 Dio 인스턴스
//   final _dio = Dio();
//   // 녹음 중 여부 플래그
//   bool _isRecording = false;
//   // 녹음 타이머
//   Timer? _recordingTimer;
//   // Server와의 세션 연결을 Unique하게 만들기 위한 Session_id
//   late String _sessionId;
  
//   // 서버 Base URL 설정
//   static const String baseUrl = 'http://localhost:9090';
  
//   AudioRecorder() {
//     // Dio 기본 설정
//     // baseUrl 설정
//     _dio.options.baseUrl = baseUrl;
//     // 연결 및 응답 받기 타임아웃 설정
//     _dio.options.connectTimeout = const Duration(seconds: 5);
//     _dio.options.receiveTimeout = const Duration(seconds: 20);
//     // 필요한 경우 인증 헤더 추가
//     // _dio.options.headers = {
//     //   'Authorization': 'Bearer your-token',
//     // };
//     final _sessionId = _dio.get(
//         '/session'  // 실제 서버의 엔드포인트로 변경 필요
//       );
//   }

//   Future<void> startRecordingAndTranscribing(int recordSeconds) async {
//     // 오디오 녹음 권한 확인
//     if (await _audioRecorder.hasPermission()) {
//       // 녹음 중 플래그 활성화
//       _isRecording = true;
      
//       try {
//         // 녹음 중 반복 처리
//         while (_isRecording) {
//           // 오디오 녹음 시작 및 파일 경로 받기
//           final path = await _startRecording();
//           // 녹음 파일이 정상적으로 생성된 경우
//           if (path != null) {
//             // 서버로 오디오 파일 전송 및 응답 받기
//             final response = await _sendAudioToServer(path);
//             print('서버 응답: $response');
//             // 임시 녹음 파일 삭제
//             await File(path).delete();
//           }
//         }
//       } catch (e) {
//         print('Error in recording/sending: $e');
//         // 녹음 중 플래그 비활성화
//         _isRecording = false;
//       }
//     }
//   }

//   Future<String?> _startRecording() async {
//     try {
//       // 임시 디렉토리 경로 가져오기
//       final directory = await getTemporaryDirectory();
//       // 오디오 파일 경로 생성
//       final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      
//       // 오디오 녹음 시작
//       await _audioRecorder.start(
//         path: path,
//         encoder: AudioEncoder.wav,
//         samplingRate: 48000,
//         numChannels: 1,
//       );

//       // 10초 동안 녹음
//       await Future.delayed(const Duration(seconds: 10));
//       // 오디오 녹음 중지
//       await _audioRecorder.stop();
      
//       // 생성된 오디오 파일 경로 반환
//       return path;
//     } catch (e) {
//       print('Recording Error: $e');
//       // 오디오 녹음 중 오류 발생 시 null 반환
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>> _sendAudioToServer(String filePath) async {
//     try {
//       // 오디오 파일 인스턴스 생성
//       final file = File(filePath);
      
//       // FormData 생성
//       // 오디오 파일을 'audio' 필드에 추가
//       final formData = FormData.fromMap({
//         'audio': await MultipartFile.fromFile(
//           file.path,
//           filename: 'audio.wav',
//         ),
//         // 필요한 경우 추가 파라미터
//         // 'language': 'ko',
//         // 'format': 'wav',
//       });

//       // POST 요청 보내기
//       final response = await _dio.post(
//         '/audio-segment/'+_sessionId,
//         data: formData,
//         options: Options(
//           contentType: 'multipart/form-data',
//           responseType: ResponseType.json,
//         ),
//       );

//       // 서버 응답 반환
//       return response.data;
//     } on DioException catch (e) {
//       print('서버 통신 에러:');
//       // Dio 예외 처리
//       if (e.response != null) {
//         print('상태 코드: ${e.response?.statusCode}');
//         print('에러 메시지: ${e.response?.data}');
//         return {'error': e.response?.data};
//       } else {
//         print('에러 메시지: ${e.message}');
//         return {'error': e.message};
//       }
//     } catch (e) {
//       print('일반 에러: $e');
//       return {'error': e.toString()};
//     }
//   }

//   void terminate() {
//     // 녹음 중 플래그 비활성화
//     _isRecording = false;
//     // 녹음 타이머 취소
//     _recordingTimer?.cancel();
//     // 녹음기 인스턴스 정리
//     _audioRecorder.dispose();
//     // Dio 인스턴스 정리
//     _dio.close();
//   }
// }