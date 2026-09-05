#!/bin/bash
# Vajra OS — PDF Toolkit
# Problem: People need to merge, split, compress, convert PDFs but can't.
case "${1:-help}" in
    merge)
        OUT="${@: -1}"; INPUTS="${@:1:$#-1}"
        [ -z "$OUT" ] && echo "  Usage: vajra-pdf merge <f1.pdf> <f2.pdf> ... <output.pdf>" && exit 1
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$OUT" $INPUTS 2>/dev/null
        echo "  Merged to $OUT"
        ;;
    split)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-pdf split <file.pdf>" && exit 1
        pdfseparate "$FILE" "${FILE%.pdf}-page-%d.pdf" 2>/dev/null; echo "  Split into pages"
        ;;
    compress)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-pdf compress <file.pdf>" && exit 1
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile="compressed-$FILE" "$FILE" 2>/dev/null
        echo "  Compressed: compressed-$FILE"
        ;;
    to-text)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-pdf to-text <file.pdf>" && exit 1
        pdftotext "$FILE" "${FILE%.pdf}.txt" 2>/dev/null; echo "  Text: ${FILE%.pdf}.txt"
        ;;
    to-images)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-pdf to-images <file.pdf>" && exit 1
        pdftoppm -png "$FILE" "${FILE%.pdf}-page" 2>/dev/null; echo "  Converted to PNG"
        ;;
    info)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-pdf info <file.pdf>" && exit 1
        pdfinfo "$FILE" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra PDF Toolkit: merge, split, compress, to-text, to-images, info"
        ;;
esac
