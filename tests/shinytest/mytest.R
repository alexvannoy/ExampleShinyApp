app <- ShinyDriver$new("../../")
app$snapshotInit("mytest")

app$setInputs(n = 199)
app$setInputs(n = 200)
app$snapshot()
