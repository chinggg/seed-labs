
LAB    = Crypto_RSA
LABPDF = $(LAB).pdf

CF     = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex


all: $(LABPDF)

%.pdf: %.tex $(DEPEND) 
	pdflatex $<
	pdflatex $<


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

task1:
	gcc task1.c -o task1.out -lcrypto

task2:
	gcc task2.c -o task2.out -lcrypto

task3:
	gcc task3.c -o task3.out -lcrypto

task4:
	gcc task4.c -o task4.out -lcrypto

task5:
	gcc task5.c -o task5.out -lcrypto
