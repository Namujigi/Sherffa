from save_audio import AudioRecorder
import time

def main():
    recorder = AudioRecorder()
    try:
        while True:
            audio_file = recorder.record_audio(10)  # 10초 녹음
            print(f"저장된 파일: {audio_file}")
            print(recorder.transcribe_audio_notapi(audio_file))
            time.sleep(1)  # 다음 녹음까지 약간의 대기
    except KeyboardInterrupt:
        print("\n녹음을 종료합니다.")
    finally:
        recorder.terminate()

if __name__ == "__main__":
    main()