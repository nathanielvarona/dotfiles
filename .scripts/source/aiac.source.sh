function aiac_ollama() {
  aiac "$@" --backend=ollama --ollama-url=http://127.0.0.1:11434/api --model=mistral
}

function aiac_gpt() {
  aiac "$@" --backend=openai --model=gpt-4
}
