#!/bin/bash
if command -v python3 &>/dev/null; then
    python3 create-markdown.py 
else
    python create-markdown.py 
fi
