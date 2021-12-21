package shell
import (
"io"
"os"
"github.com/itchio/go-brotli/dec"
//"github.com/itchio/go-brotli/enc"
)

func UNBR(INPUT string, OUTPUT string) error{
	archiveReader, err := os.Open(INPUT)

	brotliReader := dec.NewBrotliReader(archiveReader)
	defer brotliReader.Close()

	decompressedWriter, _ := os.OpenFile(OUTPUT, os.O_CREATE|os.O_WRONLY, 0644)
	defer decompressedWriter.Close()
	io.Copy(decompressedWriter, brotliReader)
	return err
}
