# Author: mcmayer
# (C) Markus Mayer
# Date: 2016-05-17
#
# Analyse the stackexchange data
#

load('stackexchange.RData')     # load dataframe 'stackexchange'

# Quantiles of log(#answers)
png("images/distrib-answers.png", width=600, height=400)
plot(rev(log10(sort(stackexchange[,'answers']))), type='o', 
     ylab="log(#answers)", xlab='rank', main="Quantiles of log(#answers)")
dev.off()

# Quantiles of log(#users)
png("images/distrib-users.png", width=600, height=400)
plot(rev(log10(sort(stackexchange[,'users']))), type='o', 
     ylab="log(#users)", xlab='rank', main="Quantiles of log(#users)")
dev.off()

# number of answers  vs. #users
png('images/answers-users.png', width=600, height=400)
plot(log10(stackexchange[,'users']), log10(stackexchange[,'answers']),
     xlab="log(#users)", ylab="log(#answers)", main="#answers vs. #users")
points(log10(stackexchange[1,'users']), log10(stackexchange[1,'answers']), col='red')
dev.off()

# number of questions answered vs. questions asked
png('images/questions-answers.png', width=600, height=400)
plot(log10(stackexchange[,'questions']), log10(stackexchange[,'answers']),
     xlab='log(#questions)', ylab='log(#answers)', main="#answers vs. #questions")
points(log10(stackexchange[1,'questions']), log10(stackexchange[1,'answers']), col='red')
dev.off()

# number of questions answered vs. questions asked
png('images/answered-users.png', width=600, height=400)
plot(log10(stackexchange[,'users']), stackexchange[,'answered'],
     xlab='log(#users)', ylab='% answered', main="% answered vs. #users")
points(log10(stackexchange[1,'users']), stackexchange[1,'answered'], col='red')
dev.off()

# age vs. users
png('images/age-users.png', width=600, height=400)
a = stackexchange[,'age']
u =  log10(stackexchange[,'users'])
plot(a, u, xlab='age/years', ylab='log(#users)', main="age/years vs. #users")
points(a[1], u[1], col='red')
smu = supsmu(a[-1], u[-1], bass=1)
lines(smu, col='blue')
dev.off()

