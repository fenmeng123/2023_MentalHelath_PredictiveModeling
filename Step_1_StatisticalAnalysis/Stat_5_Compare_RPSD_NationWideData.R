gender.crosstab = matrix(
  c(74883,85427402,75782,95911552),
  nrow = 2,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(gender.crosstab)
print(res)

phase.crosstab = matrix(
  c(59450,24944529,
    56436,49140893,
    34779,107253532),
  nrow = 3,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(phase.crosstab)
print(res)

region.crosstab = matrix(
  c(69815,66752545,
    17201,8553922,
    31821,52508670,
    31828,51852807),
  nrow = 4,
  ncol = 2,
  byrow = T,
)
res <- chisq.test(region.crosstab)
print(res)