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
	pdflatex -shell-escape author_ms
	biber author_ms
	pdflatex -shell-escape author_ms
	pdflatex -shell-escape author_ms


si: 
	pdflatex -shell-escape author_si
	biber author_ms
	pdflatex -shell-escape author_si
	pdflatex -shell-escape author_si

bib:
	pdflatex -shell-escape author_ms
	pdflatex -shell-escape author_si
	biber author_ms

# for long-running jobs use --ExecutePreprocessor.timeout=None 
analysis: export_env
	jupyter nbconvert --execute --to pdf ./author_analysis.ipynb 

fig1: 
	pdflatex author_fig1.tex

fig2: 
	pdflatex author_fig2.tex

figs: analysis fig1 fig2


# remove intermediate latex files aux, log and stash backup files
# move
clean_aux:
	latexmk -c 
	if [ -e *~ ]; then mv *~ _bak; fi

# multiple passes to get the zref cross-document cross references right
all: figs bib si ms si ms si 


# build everything then wipe the intermediate stuff
for_upload: all clean_aux


