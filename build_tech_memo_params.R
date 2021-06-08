library(NMFSReports)

sections = c("frontmatter", "abstract", "introduction", "methods & results",
             "discussion", "endmatter")
authors = "Matt & Jordan"
title = "Automated and Operational access to environmental data for Alaska’s management areas"
styles_reference_pptx = "refppt_nmfs"
styles_reference_docx = "refdoc_noaa_tech_memo"
#bibliography.bib = "bib_example"
bibliography.bib = "webservice_biblio.bib"
csl = "bulletin-of-marine-science"

buildReport(
  sections = sections,
  report_authors = authors,
  report_title = title,
  styles_reference_pptx = styles_reference_pptx,
  styles_reference_docx = styles_reference_docx,
  bibliography.bib = bibliography.bib,
  csl = csl
)