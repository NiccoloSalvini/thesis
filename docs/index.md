--- 
title: "REST API for Real Estate rental data, a spatial Bayesian modeling approach with INLA."
author: "[Niccolò Salvini](https://niccolosalvini.netlify.app/)"
url: 'https://niccolosalvini.github.io/Thesis/'
date: "Last compiled on 05 novembre, 2020"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
classoption: oneside
bibliography: [refs.bib, Rpackages.bib]
biblio-style: apalike
link-citations: yes
github-repo: NiccoloSalvini/Thesis
favicon: "images/favicon.ico" 
cover-image: "images/spat-touch.png"
description: " Niccolò Salvini master's thesis project"
apple-touch-icon: "images/spatial.png"
apple-touch-icon-size: 120
papersize: a4
geometry: "left=4cm, right=3cm, top=3cm, bottom=3cm"  
fontsize: 12pt
linestretch: 1.5
toc-depth: 2
fig_width: 7
fig_height: 6
fig_caption: true
links-as-notes: true  
lot: true 
lof: true
---



# Preliminary Content {-}

## Abstract {-}




This thesis has the aim to asses the problem of estimation and prediction for monthly rent prices in Milan Real Estate taking into consideration house characteristics. Data originates in immobiliare.it and is extracted by tailor made scraping techniques wrapped into a REST API, with Plumber, an R framework. The API infrastructure passes through the building of a custom docker image to being served in a AWS EC2 instance secured and load balanced with NGINX. Data coming from the API is Geospatial so special techniques are required. A hierarchical Bayesian modeling is followed since it can handle bias and nested parameter more comfortably. A regression setting is proposed on the basis on both economic literature suggestion and interpretability. Integrated Nested Laplace Approximation methodology reduces the spatial process to a GMRF representation of the surface through Stochastic Partial Differential Equation. The benefit is sparse matrix representation of the process for which can be used numerical methods. The model is evaluated and wrapped into a shiny app back end. Visualization are by ggplot2, leaflet and in some cases rayshader.

## Acknowledgements {-}

First of all I acknowledge a special debt to **Professor Della Vedova** who has patently followed me during this 6 months long journey, he has encouraged me and let me try things never done before. Our communication through this process has always been transparent and each moment spent was a lesson to learn. I came with strong ideas to his office desk and he let me shape my dissertation giving me blank paper. Most of all when something was not working he has always been keen to solve and suggest a better approach. I owe a lot also to Dr. **Vincenzo Nardelli**, he is one of the kindest and most talented guys I have ever met. I took a big inspiration by its works. He has been a true street opener to me, he introduced me to web scraping, then to our newly born social platform Data Network and then to the Spatial Statistics. Sometimes I feel like I am copying him, but then I realize that it is inspiration. I owe also a huge thanks to **professor Lucia Paci**. She has been one of the top teacher in my master course to me by far. She has the capability to explain very hard stuff with ease without omitting anything. She narrowed my path through bayesian methods for spatial statistics, since she was co-author of one of the main book references that I got. The bayesian statistical part relies on her thoughts and on her experience on the subject. 
I will not for sure miss to thank my beautiful girlfriend **Elisabetta**, She has seen my darkest times and my deepest insecurities, she did not even blink and she kept helping me like day one. Without her really anything would not have been even possible. She is so smart and she know me so well that when I had downs, even though she had had her own issues, she carried the weights and broght the only medicine I know: "Sciacchiata o Gelato". I would love to thank my father **Muzio** to be such a big milestone both in my career and private life, he has always encouraged me pursuing my dream by never setting any sort of limit. Its life could be compressed into a Frank Sinatra song "My Way" and observing him, working speakly, I wish the future would bless me with its same independence and freedom. Special thanks are dedicated also to my beloved uncles, zia **Jolanda** and zio **Luciano**.  They put a stake on me, they always make me feel special and talented even though university has never given me the chance to truly express myself. Me and Zio Luciano conversations are inspirational, he knows all the ropes, he is the most talented business man I am ever going to see in my entire life, I wish I could have a tenth of its talent. What I do is mainly because of its enormous successes and sacrifices. Memory is just for people that have to rely on past to act in the present. You take care of today so that tomorrow you can shape the future. Zia Jolanda you gave me back the most important thing, family, you have never missed special and difficult moments. You supported me and my mother throughout our exhausting journey I would never find the words and express much gratitude for what you did. You are an angel. 
To all my friend thanks for each of your unspecified different support, unfortunately this is becoming too long, a party is going to happen and a piece of a paper will do justice.

## Dedication {-}

To my beloved mother, Maria Cristina. She has done so much for me you would not even know. We have been facing fires and flames for God knows how long, and now look where we are. You can not imagine how strong she is and if you do it please try to explain me then. I have always thought that mothers have this type of superpowers, but I belive me my mother exaggerates.
Our relationship has never been easy, we have both of us strong attitudes, nevertheless we keep on persisting and the reason is that we can not be set apart. Never.
The most I have done since I remember is for her and for her satisfaction. I do not regret it. She is my inspiration, and I hope someday that I will live up to you mamma. she went "all in" sending me in Milan. 
She did right.
Mum's always right.


_keywords_ : Bayesian Statistics, RESTFUL API, Shiny, Docker, AWS EC2, INLA, Real Estate, Web Scraping, Parallel Computing, Cron Job Scheduler.



# Appendix {-}

## GP basics
[Nando de Freitas](https://www.youtube.com/watch?v=4vGiHC35j9s&t=164s)

lets say there are a cloiud of points represented by two variables x1 and x2. the cloud of points describesa  realization of theis two varibale i.e. hight and weight and then you just plot it , you might get mesaurament like that , 

![gp cloud of points ](appendix_images/gp_base_1.jpg)
or: each circle is a mesuduraments. now when we use multivariate gaussian we fit gaussian to data, the process of learning is to fit a gaussian to data, the ultimate goal is to describe the data, the smartest gaussian in the first image is to center the mean in the 0 and the draw a cricle containin all the other observation. Instaed for the second image it is still centering the mean in 0 but now it is an ellipse describing the variability, the size of the elipse descrube the variability of the data.
the center is a vector $\mu_{i}$ that it is beacuse we have two components $x_1$ and $x_2$ whhose mean is 0 for each of the other. This is true for all the observation which have two coordinates too $x_1$ and $x_2$. in vector notations we have for the mean:

$$
\boldsymbol{\mu}=\left[\begin{array}{l}
\mu_{x_1} \\
\mu_{x_2}
\end{array}\right]
$$

for each of the points, e.g. for point 1:

$$
\mathbf{x_1}=\left[\begin{array}{l}
x_1 \\
x_2
\end{array}\right]
$$

the can be neagtive positive, the Real numbers, usually we have $\mathbb{R}^{2}$ extending from - infinity to + infinity, to the power of two because we have 2 dimensions, a Real plane.

any point is gaussian distributed when with mean .. an variance. 
how we explain covariance, thorugh _correlation._
we do it by correlation with its noraml forms. the covariance is the term that goes insisde the matrices in the upper right of the matrxi we have the expectation of $x_1$ times $x_2$, like $\mathbb{E}(x_1 \cdot x_2)$, where the extactation in the gaussian case is the mean which is 0, so the corresponding values is 0.
the covariance essentially is the dot product of $x_1$ and $x_2$ what happens when you take the dot product of vectors, if for example you take a vector tgat looks like 1 and 0 ... dot product measure similarity. if rwo poiints are closed in two dimension then the dot will be height.


whene you plot in three D you can plot the joint distribiution which is bell shaped as gaussians are. 

sigma 1 and signa 2 if you have 1 d varibale the widjth has to be postive, for mulitvariate gaussian equl so here positive definitness: covariance mateix symetric.  



<!-- AUTO COMPILE packages.bib -->

<!-- ```{r include=FALSE} -->
<!-- # automatically create a bib database for R packages -->
<!-- knitr::write_bib(c( -->
<!--   .packages(), 'bookdown', 'knitr', 'rmarkdown' -->
<!-- ), 'packages.bib') -->
<!-- ``` -->

