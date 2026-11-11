#!/bin/bash

echo "Đang kiểm tra Ollama service..."
ollama list > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Ollama chưa được khởi chạy. Vui lòng bật Ollama trước!"
    exit 1
fi

echo "Đang tải Base Model..."
ollama pull qwen2.5
ollama pull nomic-embed-text

echo "Đang build Custom Model cho dự án..."
ollama create haui-chatbot -f ./models/Modelfile

echo "Đã build thành công model 'haui-chatbot'!"