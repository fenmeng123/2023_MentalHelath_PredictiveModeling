bruceR::set.wd()
sink('../Res_1_Logs/Log_Table_S1.txt',
     type = 'output',
     append = F)
gender.crosstab = matrix(
  c(78725,59489243,82237,66399805),
  nrow = 2,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(gender.crosstab)
print(res)

phase.crosstab = matrix(
  c(62858,51803626,
    60692,49140893,
    37412,24944529),
  nrow = 3,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(phase.crosstab)
print(res)

region.crosstab = matrix(
  c(74813,45999068,
    18567,6210804,
    33876,36924705,
    33706,36754471),
  nrow = 4,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(region.crosstab)
print(res)
sink()