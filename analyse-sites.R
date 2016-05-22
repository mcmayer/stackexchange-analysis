# Author: mcmayer
# (C) Markus Mayer
# Date: 2016-05-17
#
# Analyse the stackexchange data
#

load('sites.RData')     # load dataframe 'stackexchange'
load('data.RData')      # load dataframe 'data'

# combine the two datasets
sites = cbind(sites, data[sites[,'link'],c('comments', 'tags')])
rm(data)

# Quantiles of log(#questions) and log(#users)
png("images/quantiles.png", height=10, width=15, units = 'cm', res=300)
questions = rev(log10(sort(sites[,'questions'])))
users = rev(log10(sort(sites[,'users'])))
plot(users, type='l', ylim= range(c(answers, users)),
     ylab="log10(count)", xlab='rank', 
     main="Quantiles of log(#questions), log(#users)",
     col='red', lwd=2)
lines(questions, type='l', col='blue', lty=2, lwd=2)
legend(80,7,c('log10(#questions)', 'log10(#users)'), lwd=2, col=c('red','blue'),
       lty=c(1,2), cex=.7)
dev.off()

# number of answers  vs. #users
png('images/answers-users.png', height=10, width=15, units = 'cm', res=300)
plot(log10(sites[,'users']), log10(sites[,'answers']),
     xlab="log(#users)", ylab="log(#answers)", main="#answers vs. #users")
points(log10(sites[1,'users']), log10(sites[1,'answers']), col='red')
reg = lm(log10(answers)~log10(users), data=sites)
text(sum(range(reg$model[,2]))/2,7, 
     sprintf("%s = %1.3f * %s %+1.3f", colnames(reg$model)[1], round(reg$coeff[2],3), colnames(reg$model)[2], round(reg$coeff[1],3)),
      cex=.7, col='blue')
abline(reg, col='blue')
dev.off()

# number of questions answered vs. questions asked
png('images/questions-answers.png', height=10, width=15, units = 'cm', res=300)
plot(log10(sites[,'questions']), log10(sites[,'answers']),
     xlab='log(#questions)', ylab='log(#answers)', main="#answers vs. #questions")
points(log10(sites[1,'questions']), log10(sites[1,'answers']), col='red')
reg = lm(log10(answers)~log10(questions), data=sites)
text(sum(range(reg$model[,2]))/2, 7, 
     sprintf("%s = %1.3f * %s %+1.3f", colnames(reg$model)[1], round(reg$coeff[2],3), colnames(reg$model)[2], round(reg$coeff[1],3)),
     cex=.7, col='blue')
abline(reg, col='blue')
dev.off()

# % questions answered vs. questions asked
png('images/answered-users.png', height=10, width=15, units = 'cm', res=300)
plot(log10(sites[,'users']), sites[,'answered'],
     xlab='log(#users)', ylab='% answered', main="% answered vs. #users")
points(log10(sites[1,'users']), sites[1,'answered'], col='red')
reg = lm(answered~log10(users), data=sites)
abline(reg, col='blue')
dev.off()

# users vs. site age
png('images/age-users.png', height=10, width=15, units = 'cm', res=300)
a = sites[,'age']
u =  log10(sites[,'users'])
plot(a, u, xlab='site age/years', ylab='log(#users)', main="site age/years vs. #users")
points(a[1], u[1], col='red')
smu = supsmu(a[-1], u[-1], bass=1)
lines(smu, col='blue')
rm(a,u,smu)
dev.off()

# site growth (questions) vs. site age
png('images/age-growth.png', height=10, width=15, units = 'cm', res=300)
a = sites[,'age']
g =  log10(sites[,'questions']/(a+1/12))
ylim = range(g); ylim = ylim + c(-.2, .2)
plot(a, g, xlab='site age/years', ylab='log(Site growth: Questions/year)', 
     ylim=ylim, main="Average site growth (questions per year) vs. site age")
i = grep('Stack Overflow.*', rownames(sites))
points(a[i], g[i], col='red', lwd=2, cex=.9)
text(a[i], g[i], rownames(sites)[i], pos=3, cex=.5, col='red')
smu = supsmu(a[-1], g[-1], bass=1)
lines(smu, col='blue')
rm(a,g,smu, ylim)
dev.off()

# site growth (users) vs. site age
png('images/age-user-growth.png', height=10, width=15, units = 'cm', res=300)
a = sites[,'age']
g =  log10(sites[,'users']/(a+1/12))
ylim = range(g); ylim = ylim + c(-.2, .2)
plot(a, g, xlab='site age/years', ylab='log(Average site growth: Users/year)', 
     ylim=ylim, main="Average site growth (users per years) vs. site age")
i = grep('Stack Overflow.*', rownames(sites))
points(a[i], g[i], col='red', lwd=2, cex=.9)
text(a[i], g[i], rownames(sites)[i], pos=3, cex=.5, col='red')
smu = supsmu(a[-1], g[-1], bass=1)
lines(smu, col='blue')
rm(a,g,smu, ylim)
dev.off()

# #comments vs. #answers
png('images/answers-comments.png', height=10, width=15, units = 'cm', res=300)
plot(log10(sites[,'comments']), log10(sites[,'answers']),
     ylab="log(#comments)", xlab="log(#answers)", main="#comments vs. #answers")
points(log10(sites[1,'comments']), log10(sites[1,'answers']), col='red')
reg = lm(log10(answers)~log10(comments), data=sites)
text(sum(range(reg$model[,2]))/2, 7, 
     sprintf("%s = %1.3f * %s %+1.3f", colnames(reg$model)[1], round(reg$coeff[2],3), colnames(reg$model)[2], round(reg$coeff[1],3)),
     cex=.7, col='blue')
abline(reg, col='blue')
dev.off()

# #tags vs. #questions
png('images/tags-questions.png', height=10, width=15, units = 'cm', res=300)
plot(log10(sites[,'questions']), log10(sites[,'tags']),
     xlab="log(#questions)", ylab="log(#tags)", main="#questions vs. #tags")
points(log10(sites[1,'questions']), log10(sites[1,'tags']), col='red')
reg = lm(log10(tags)~log10(questions), data=sites, subset=log10(sites[1,'questions'])>3)
text(sum(range(reg$model[,2]))/2, 4.5, 
     sprintf("%s = %1.3f * %s %+1.3f", colnames(reg$model)[1], round(reg$coeff[2],3), colnames(reg$model)[2], round(reg$coeff[1],3)),
     cex=.7, col='blue')
abline(reg, col='blue')
dev.off()
