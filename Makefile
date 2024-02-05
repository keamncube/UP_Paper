# Makefile to run the analysis for the paper and compile the manuscript

## Recursively look for all files in the current directory and its subdirectories
VPATH = $(shell find . -type d)

## List of inputs
INPUT_TARGETS = artifacts_BA900.rds \
artifacts_BA930.rds artifacts_BA930_futher_analysis.rds \
artifacts_competion_narratives.rds artifacts_macropru_narratives.rds \
artifacts_BA920.rds \
artifacts_controls.rds \
artifacts_data_check.rds \
artifacts_modelling_data.rds \
artifacts_descriptives.rds \
artifacts_macropru_models.rds \
artifacts_competition_models.rds

## Generating the manuscript 
UP_paper.pdf: UP_paper.qmd $(INPUT_TARGETS)
	quarto render $<
	
## Generating rds inputs to manuscript
artifacts_BA900.rds: 01_BA900.R BA900_line_item_103_to_277_updated_to_Aug_2023.xlsx
	Rscript $<

artifacts_BA930.rds: 02_BA930.R $(wildcard 4.1 BA930 Multiple Bank Export (*).xlsx)
	Rscript $<

artifacts_BA920.rds: 03_BA920.R BA920_data.xlsx
	Rscript $<
	
artifacts_competion_narratives.rds: 04_competition_narrartives.R Competition_and_inclusion_narrative_index_10122023.xlsx
	Rscript $<

artifacts_macropru_narratives.rds: 05_macropru_narratives.R plot_narratives_post_2008.xlsx
	Rscript $<

artifacts_BA930_futher_analysis.rds: 06_lending_rates_further_analysis.R \
artifacts_BA930.rds artifacts_BA900.rds
	Rscript $<
	
artifacts_controls.rds: 07_bank_controls.R ERD_data_request.xlsx
	Rscript $<
	
artifacts_data_check.rds:	08_data_check.R \
artifacts_macropru_narratives.rds artifacts_competion_narratives.rds \
artifacts_BA900.rds artifacts_BA930_futher_analysis.rds artifacts_BA920.rds
	Rscript $<

artifacts_modelling_data.rds: 09_preprocessing.R \
artifacts_data_check.rds \
artifacts_competion_narratives.rds \
artifacts_controls.rds
	Rscript $<

artifacts_descriptives.rds: 10_descriptives.R \
artifacts_modelling_data.rds
	Rscript $<

artifacts_macropru_models.rds: 11_prelim_macropru_models.R \
artifacts_modelling_data.rds
	Rscript $<

artifacts_competition_models.rds: 12_prelim_competition_models.R \
artifacts_modelling_data.rds
	Rscript $<
	

