library("crul")

base_url <- "https://nsidc.org/api/dataset/2/OpenSearch"

nsidc_scrape <- function(query = "*:*", count = 100, start = 1) {
  cli <- crul::HttpClient$new(url = base_url)
  args <- list(searchTerms = query, startIndex = start, count = count)
  res <- cli$get(query = args, verbose = TRUE)
  xml <- xml2::read_xml(res$parse("UTF-8"))
  xml2::xml_ns_strip(xml)
  entries <- xml2::xml_find_all(xml, ".//entry")

  get <- c('', '', '', '', '')
  invisible(lapply(entries, function(z) {
    tmp <- jsonlite::toJSON(xml2::as_list(z), auto_unbox = TRUE)
    cat(tmp, sep = "\n", file = "nsidc_from_opensearch.json", append = TRUE)
  }))
}

# scrape all pages
lapply(c(1, seq(100, 1000, 100)), function(z) nsidc_scrape(start = z))
