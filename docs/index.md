--- 
title: "RESTful Scraping API for Real Estate data, a Spatial Bayesian modeling perspective with INLA"
author: 
- "Candidate: [Niccolò Salvini](https://niccolosalvini.netlify.app/)"
- "Supervisor: [Phd Marco L. Della Vedova](https://mldv.it/home/)"
- "Assistant Supervisor: [PhD Vincenzo Nardelli](https://github.com/vincnardelli)"
url: 'https://niccolosalvini.github.io/Thesis/'
date: "Lastest book build: 02 febbraio, 2021"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
classoption: oneside
bibliography: [refs.bib, Rpackages.bib]
biblio-style: apalike
link-citations: yes
github-repo: NiccoloSalvini/thesis
favicon: "images/logo/spatial_logo.ico" 
cover-image: "images/logo/spatial_logo.png"
description: "This is Niccolò Salvini master's thesis project"
apple-touch-icon: "images/logo/spatial_logo.png"
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

<!-- VALUTARE SE METTERE NEL DOCUMENTO FINALE -->


# Preliminary Content {-}

## Abstract {-}




The following work has the aim to build a robust Scraping API service to extract Real Estate rental data (Milan, IT) and applying _geostatistics_ spatial modeling through a convenient computing alternative called INLA.
Data originates from immobiliare.it database and it is extracted through a _scraper_ built on top of the website. The scraper is _optimized_ with respect to both the server side _kindly requesting_ permission and imposing _delayed-request rates_, and the client side by granting continuity through _fail dealers_ and request's _headers rotation_. Scraping functions exploit a custom workflow that combines url reverse engineering and optimal search strategies within the website. Speed comes from the fact that differently from spiders and derivatives which operate a full crawling down of the web site, the workflow concentrates only on a restricted set of urls. A further critical speed boost is offered by parallelism through the latest _Future_ back-end, and a run time benchmark demonstrates the scraper rapidity for two recent parallel with two configurations.
The scraper is then wrapped into a http API through an R framework, namely _Plumber_. Security is a major focus and anti dossing strategies, HTTPS and sanitization are singularly treated.
Docker can offer a lightweight environment where dependencies are conveniently organized making the software portable. As a result the whole API service is _containerized_ and built upon custom Dockerfiles, which are orchestrated by _Compose_  through a .yml file. Amazon EC2 is an AWS web service providing a stable, scalable cloud computing capability in which the system is hosted. The service choice is a free tier one. Along with the server it comes the need of a reverse proxy service and the choice falls on _NGINX_ reverse proxy server for authentication and load balancing. The architecture principles stacked on top of the http API elevates it to being RESTful. RESTful APIs are a mean of communication among internet services that allows to perform any kind of action without having both parts to know how they are implemented.
In other words, if the client wants to interact with a web service with the aim to retrieve information or perform a function, a RESTful API land a hand by communicating the _desiderata_ to that system so it can understand and fulfill the request in a secured and structured way.
Software CI/CD is managed through automatic workflow that exploits GitHub and DockerHub, which ultimately allows containers to be pulled into the EC2. Once the RESTful API endpoint is invoked, data, in this case Milan rental market within the municipality borders, is asynchronously scraped and collected into a JSON format.
Traditional spatial bayesian methods have been generally slow in the context of spatial big data since covariance matrices are dense and their inversions scale to a cubic order. Therefore Integrated Nested Laplace approximation (INLA) is applied constituting a faster computational alternative on a special type of models called Latent Gaussian models (LGM). _INLA_ shorten computations through analytics approximations with Laplace and numerical methods for space matrices with the aim to obtain an approximated posterior distribution of the parameters.
Hedonic Price Models (HPM) constitutes the economic theoretical foundation of the model according to which the linear predictor is set. As a matter of fact house prices are related to the value of the property by their demand-offer price equilibra for each single characteristic (including the spatial ones). A further aspects addresses the fact that prices are considered as a proxy value for rents since they are both interchangeable economic actions satisfying the same need. However the critical part of studying house characteristics in geostatistics is the _estimation_ for the reason already anticipates.
LGMs are defined into a hierarchical bayesian modeling framework, distinguishing three nested hierarchy levels: the likelihood of the data (generally an exponential family), the latent Gaussian Markov Random Field GRMF (where the linear predictor is) and the hyper parameter distribution for which priors are specified. GMRF are suitable since they provide a sparse precision matrix due to conditional assumption, marking matrices tridiagonal. The spatial component of the data is considered as a discrete realization of an underlying unobserved and continuous Gaussian Process (GP) to be estimated, completely characterized by a mean structure and a covariance matrix. For the Gaussian Process are made two major assumptions: stationarity and isotropy, which let specifying a flexible covariance function i.e. Matérn.
The Stochastic Partial Differential Equations (SPDE) solutions can provide a GMRF representation of the GP whose covariance matrix is Matérn. This happens through a triangulation of the domain of the study said mesh. The model is then fitted and cross validated with R-INLA and inference on parameter posterior distribution is given. 

## Acknowledgements {-}

First of all I acknowledge a special debt to **Professor Della Vedova** who has patently followed me during this 6 months long journey, he has encouraged me and let me try things never done before. Our communication through this process has always been transparent and each moment spent was a lesson to learn. I came to his office desk with strong ideas and he let me shape my dissertation giving me carte blanche. Most of all when something was not working he has always been keen to solve and suggest a better approach. I owe a lot also to Dr. **Vincenzo Nardelli**, he is one of the kindest and most talented guys I have ever met. I took a big inspiration by its works. He has been a true street opener to me, he introduced me to web scraping, then to our newly born social platform Data Network and then to the Spatial Statistics. Sometimes I feel like I am copying him, but then I realize that it is just inspiration. I owe also a huge thanks to **Professor Lucia Paci**. She has been one of the top teacher in my master course to me by far. She has the capability to explain very hard stuff and to transpose it in the easiest way possible. She narrowed my path through bayesian methods for spatial statistics, since she was co-author of one of the main book references that I got. The bayesian statistical intuition relies on her thoughts and on her experience on the subject. 
I will not for sure miss to thank my beautiful girlfriend **Elisabetta**, She has seen my darkest times and my deepest insecurities, she did not even blink and she kept helping me like day one. Without her really anything would not have been even possible. She is so smart and she know me so well that when I had downs, even though she had had her own issues, she carried the weights and broght the only medicine I know: "Sciacchiata o Gelato". I would love to thank my father **Muzio** to be such a big milestone both in my career and private life, he has always encouraged me pursuing my dream by never setting any sort of limit. Its life could be compressed into a Frank Sinatra song "My Way" and observing him, working speakly, I wish the future would bless me with its same independence and freedom. Special thanks are dedicated also to my beloved uncles, zia **Jolanda** and zio **Luciano**.  They put a stake on me, they always make me feel special and talented even though university has never given me the chance to truly express myself. Me and Zio Luciano conversations are inspirational, he knows all the ropes, he is the most talented business man I am ever going to see in my entire life, I wish I could have a tenth of its talent. What I do is mainly because of its enormous successes and sacrifices. Memory is just for people that have to rely on past to act in the present. You take care of today so that tomorrow you can shape the future. Zia Jolanda you gave me back the most important thing, family, you have never missed special and difficult moments. You supported me and my mother throughout our exhausting journey I would never find the words to express much gratitude for what you did. You are an angel. 
To all my friend thanks for each of your unspecified, different but vital support. Unfortunately this is becoming too long, a party is going to be thrown and with sincere tears and a piece of a paper I will do justice.

## Dedication {-}

To my beloved mother, Maria Cristina. She has done so much for me you would not even know. We have been facing fires and flames for God knows how long, and now look where we are. You can not imagine how strong she is and if you do, please try to explain me then. I have always thought that mothers have this type of superpowers, but believe me my mother exaggerates.
Our relationship has never been easy, we have both of us strong attitudes, nevertheless we keep on persisting and the reason is that we can not be set apart. Never.
The most I have done since I remember is for her and for her satisfaction. I do not and I would never regret it. She is my inspiration, and I hope someday that I will live up to you mamma. she went "all in" sending me in Milan.
She did right.
Mum's always right.

_keywords_ : Bayesian Statistics, RESTful API, Docker, AWS, INLA, Real Estate, Web Scraping, Parallel Computing, Hierarchical models.





<!-- AUTO COMPILE packages.bib -->

<!-- ```{r include=FALSE} -->
<!-- # automatically create a bib database for R packages -->
<!-- knitr::write_bib(c( -->
<!--   .packages(), 'bookdown', 'knitr', 'rmarkdown' -->
<!-- ), 'packages.bib', append = TRUE) -->
<!-- ``` -->



