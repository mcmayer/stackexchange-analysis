# Author: mcmayer
# (C) Markus Mayer
# Date: 2016-05-17
#
# Analyse the stackexchange data
#

load('sites.RData')     # load dataframe 'stackexchange'

# Quantiles of log(#answers)
png("images/distrib-answers.png", width=600, height=400)
plot(rev(log10(sort(sites[,'answers']))), type='o',
     ylab="log(#answers)", xlab='rank', main="Quantiles of log(#answers)")
dev.off()

# Quantiles of log(#users)
png("images/distrib-users.png", width=600, height=400)
plot(rev(log10(sort(sites[,'users']))), type='o',
     ylab="log(#users)", xlab='rank', main="Quantiles of log(#users)")
dev.off()

# number of answers  vs. #users
png('images/answers-users.png', width=600, height=400)
plot(log10(sites[,'users']), log10(sites[,'answers']),
     xlab="log(#users)", ylab="log(#answers)", main="#answers vs. #users")
points(log10(sites[1,'users']), log10(sites[1,'answers']), col='red')
dev.off()

# number of questions answered vs. questions asked
png('images/questions-answers.png', width=600, height=400)
plot(log10(sites[,'questions']), log10(sites[,'answers']),
     xlab='log(#questions)', ylab='log(#answers)', main="#answers vs. #questions")
points(log10(sites[1,'questions']), log10(sites[1,'answers']), col='red')
dev.off()

# number of questions answered vs. questions asked
png('images/answered-users.png', width=600, height=400)
plot(log10(sites[,'users']), sites[,'answered'],
     xlab='log(#users)', ylab='% answered', main="% answered vs. #users")
points(log10(sites[1,'users']), sites[1,'answered'], col='red')
dev.off()

# age vs. users
png('images/age-users.png', width=600, height=400)
a = sites[,'age']
u =  log10(sites[,'users'])
plot(a, u, xlab='age/years', ylab='log(#users)', main="age/years vs. #users")
points(a[1], u[1], col='red')
smu = supsmu(a[-1], u[-1], bass=1)
lines(smu, col='blue')
dev.off()
