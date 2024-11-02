import pyaudio
import wave
import os
from dotenv import load_dotenv
import openai
from openai import OpenAI
from pydub import AudioSegment
import torch
import whisper
client = OpenAI()

# 환경 변수에서 API 키 로드
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

class AudioRecorder:
    def __init__(self, sample_rate=48000, channels=1, chunk_size=1024):
        self.sample_rate = sample_rate
        self.channels = channels
        self.chunk_size = chunk_size
        self.format = pyaudio.paInt16  # 16비트 오디오
        self.audio = pyaudio.PyAudio()
        self.file_counter = 0

    def record_audio(self, record_seconds=10):
        print("녹음을 시작합니다...")
        stream = self.audio.open(
            format=self.format,
            channels=self.channels,
            rate=self.sample_rate,
            input=True,
            frames_per_buffer=self.chunk_size
        )
        frames = []

        # 녹음 시작
        for _ in range(0, int(self.sample_rate / self.chunk_size * record_seconds)):
            data = stream.read(self.chunk_size)
            frames.append(data)

        # 스트림 종료
        stream.stop_stream()
        stream.close()
        print("녹음이 완료되었습니다.")

        # 오디오 파일로 저장
        filename = f"audio_{self.file_counter}.wav"
        self.file_counter += 1
        with wave.open(filename, 'wb') as wf:
            wf.setnchannels(self.channels)
            wf.setsampwidth(self.audio.get_sample_size(self.format))
            wf.setframerate(self.sample_rate)
            wf.writeframes(b''.join(frames))

        # 음량 증가
        audio = AudioSegment.from_wav(filename)
        louder_audio = audio + 10  # 음량을 10dB 증가
        louder_audio.export(filename, format="wav")

        return filename

    def transcribe_audio(self, file_path):
        # OpenAI API를 사용하여 텍스트로 변환
        with open(file_path, "rb") as audio_file:
            transcription = client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file
            )
            return transcription.text
    
    def transcribe_audio_notapi(self, file_path):
        # 모델 로드 (예: base 모델)
        model = whisper.load_model("base")

        # CPU로 설정
        model.to("cpu")

        # 음성 파일을 처리
        result = model.transcribe(file_path)
        return result["text"]

    def terminate(self):
        self.audio.terminate()

