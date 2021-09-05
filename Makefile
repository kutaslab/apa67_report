# TODO: for reproducibility check we are running in the right conda environment

# where to find the files
HOME_DIR = /home/turbach/TPU_Projects/demos/latex/apa_6th_example

# jupyter notebook figure generator ... slurp the actual research data
# and generate the pdf plots that will appear in the ms and si Figures
JUPYTER_CONVERT = jupyter nbconvert --ExecutePreprocessor.timeout=None --execute 

export_env:
	conda list --explicit > environment.txt

# the minted syntax highlighting package insists on -shell-escape
ms: 
	pdflatex -shell-escape apa_ms
	biber apa_ms
	pdflatex -shell-escape apa_ms
	pdflatex -shell-escape apa_ms


si: 
	pdflatex -shell-escape apa_si
	biber apa_ms
	pdflatex -shell-escape apa_si
	pdflatex -shell-escape apa_si

bib:
	pdflatex -shell-escape apa_ms
	pdflatex -shell-escape apa_si
	biber apa_ms

# for long-running jobs use --ExecutePreprocessor.timeout=None 
analysis: export_env
	jupyter nbconvert --execute --to pdf ./apa_analysis.ipynb 

fig1: 
	pdflatex apa_fig1.tex

fig2: 
	pdflatex apa_fig2.tex

figs: analysis fig1 fig2


# remove intermediate latex files aux, log and stash backup files
# move
clean_aux:
	latexmk -c 

# multiple passes to get the zref cross-document cross references right
all: figs bib si ms si ms si 


# build everything then wipe the intermediate stuff
for_upload: all clean_aux


