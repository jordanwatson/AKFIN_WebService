#' ---
#' title: 'Automated and Operational access to environmental data for Alaska’s management areas'
#' author: 'Matt & Jordan'
#' purpose: Run Scripts and R Markdown Files
#' start date: 2021-06-07
#' date modified: 2021-06-07                                          # CHANGE
#' Notes:                                                               # CHANGE
#' ---

# START ------------------------------------------------------------------------

# *** REPORT KNOWNS ------------------------------------------------------------
report_title <- 'Automated and Operational access to environmental data for Alaska’s management areas'
report_authors <- 'Matt & Jordan'
report_yr <- substr(x = Sys.Date(), start = 1, stop = 4)            # SUGGESTION

# *** OUTPUT TYPE --------------------------------------------------------------
#Is this for InDesign?
indesign_flowin <- FALSE

# *** SOURCE SUPPORT SCRIPTS ---------------------------------------------------

source('./code/directories.R')

source('./code/functions.R')

source('./code/dataDL.R')

source('./code/data.R')



# *** RENV: SAVE PACKAGES USED TO CREATE THIS REPORT ---------------------------
# renv::init()
# renv::snapshot()

# *** SIGN INTO GOOGLE DRIVE----------------------------------------------------

# googledrive::drive_deauth()
# googledrive::drive_auth()
# 1

# MAKE REPORT ------------------------------------------------------------------

# *** HOUSEKEEPING -------------------------------------------------------------

# Keep chapter content in a proper order
cnt_chapt <- "000"
# Automatically name objects with consecutive numbers
cnt_figures <- 0 #  e.g., Figure 1
cnt_tables <- 0 # e.g., Table 1
cnt_equations <- 0 # e.g., Equation 1
# Save object content
list_equations <- list()
list_tables <- list()
list_figures <- list()

# *** RUN EACH REPORT SECTION --------------------------------------------------


# *** *** 0 - Example ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_example_")
rmarkdown::render(paste0(dir_code, "/0_example.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 1 - Frontmatter ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_frontmatter_")
rmarkdown::render(paste0(dir_code, "/1_frontmatter.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 2 - Abstract ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_abstract_")
rmarkdown::render(paste0(dir_code, "/2_abstract.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 3 - Introduction ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_introduction_")
rmarkdown::render(paste0(dir_code, "/3_introduction.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 4 - Methods & Results ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_methods & results_")
rmarkdown::render(paste0(dir_code, "/4_methods & results.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 5 - Discussion ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_discussion_")
rmarkdown::render(paste0(dir_code, "/5_discussion.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 6 - Endmatter ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_endmatter_")
rmarkdown::render(paste0(dir_code, "/6_endmatter.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".docx"))


# *** *** 7 - Presentation ------------------------
cnt_chapt<-auto_counter(cnt_chapt)
cnt_chapt_content<-"001"
filename0<-paste0(cnt_chapt, "_presentation_")
rmarkdown::render(paste0(dir_code, "/7_presentation.Rmd"),
                  output_dir = dir_out_chapters,
                  output_file = paste0(filename0, cnt_chapt_content, ".pptx"))



# SAVE OTHER OUTPUTS -----------------------------------------------------------

save(list_figures,
     file=paste0(dir_out_figures, "/report_figures.rdata"))

save(list_tables,
     file=paste0(dir_out_tables, "/report_tables.rdata"))

save(list_equations,
     file=paste0(dir_out_tables, "/report_equations.rdata"))

# MAKE MASTER DOCX -------------------------------------------------------------

#USE GUIDENCE FROM THIS LINK
#https://support.microsoft.com/en-us/help/2665750/how-to-merge-multiple-word-documents-into-one

# SAVE METADATA ----------------------------------------------------------------

con <- file(paste0(dir_out_todaysrun, "metadata.log"))
sink(con, append=TRUE)
sessionInfo()
sink() # Restore output to console
# cat(readLines("notes.log"), sep="\n") # Look at the log

