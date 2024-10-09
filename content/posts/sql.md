+++
title = 'Kotlin serialization'
date = 2024-10-09T17:39:05+03:00
draft = false
+++

I've had an issue with Facebook Messenger (not that there's more than one) where I deleted
a 3 year old groupchat, fuming from the fact that I cannot recover the conversation,
I tried pursuading my friends to use Discord, but to no avail, as 
"it's heavy and we won't be able to see our chat history!". 

So, for tackling the second point,
I've decided to build a program, that would import Messenger's group chat message data (It's available in JSON format,
but needs to be requested beforehand) into a database (Probably SQLite for simplicity, and it has [FTS][full-text-search])
and then create some functions that run SQL queries and return fun stats. E.g how many reactions has each of the group participants
given and received, what's the average interval between messages in the chat in the last week, etc., maybe even draw up some graphs

I've been getting a lot of Kotlin advertisement in my Twitter feed, it's a JVM-based language (and they also advertise
it as a [Data Science tool][kotlin-data-science]) and I've basically never touched a language this complex (Perhaps only [Ada][ada-pl], yeah, Ada is awesome)
so that is my choice for this fun project.

The code exists here: [https://github.com/adezxc/messenger-discord-bot](https://github.com/adezxc/messenger-discord-bot), it is super incomplete
and I work on it whenever I get some motivation && free time.

!! This post is still a draft, it's here only for visual feedback and a reminder for me to finish writing it !!

[full-text-search]: https://www.sqlite.org/fts5.html
[kotlin-data-science]: https://kotlinlang.org/docs/data-analysis-overview.html
[ada-pl]: https://en.wikipedia.org/wiki/Ada_(programming_language)
