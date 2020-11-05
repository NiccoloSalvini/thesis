# Scraping {#scraping}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->



The following chapter covers a gentle introduction and concepts of web scraping centered on immobiliare.it. It starts in general terms by ideally segmenting websites in two meta-concepts: website structure and content architecture, then it provokes this segmentation to the specific immobiliare.it case. The abstract workflow will ease the identification of the first "high level" challenge to be fronting during scraping, which is mainly understanding how the website is structured and how to reverse engineer the url composition. The structure is unrolled so that each part can be singularly and directly accessed and the problem can be passed to "lower levels". At this point a rooted-tree graph representation is used to map scraping functions into immobiliare content architecture. By means of `rvest` scraping is possible and the main function involved are presented. A specific function to scrape price (the response var of the analysis) is shown and then also a second function, that takes care of grouping all the scraping functions into a single one. Scraping best practices are applied both on the web server side, kindly requesting permission and delayed sending rate; and from the web client side by granting continuous scraping, avoiding server blocks by User Agent rotation and trycatches / handlers for easy debugging. Then run time issues are fronted presenting two different options for looping construction, `furrr` and `foreach`. The latter has displayed interesting results and further improvements are taken into consideration. Then an overview of the open challenges is offered so that this work might be extended or integrated with other technologies. In the end legal profiles are addressed comparing scraping results and difficulties with a counterpart case study.

## What is Web Scraping

Web Scraping is a technique aimed at extracting data from static or dynamic internet web pages. It can be applied simultaneously or automatically by a  scheduler that plans execution at a given time. Content in webpages is the most of the times well organized and accessible.
(puoi dire meglio)
This is made possible by the effort put into building both the _website structure_ and the _content architecture_. For website structure it is meant the way urls, pointing to webpages, are arranged throughout the website.
Website structure constitutes a _first dimension_ of hierarchy. Some popular structure examples might regard social-networks where posts can be scrolled down within a single url page named the wall. Scrolling down might end due to few posts, but the perception related to the scroll option is a never-ending webpage associated to a single url. Instead personal profiles are dedicated to a specified unique url and even in profiles posts are allocated into a sub domain and might be scrolled down arranged by time since the day of social subscription. Online newspapers display their articles in the front wall and by accessing to one of them all the related following articles sometimes can be reached by an arrow, pointing right or left. Articles can also be suggested and the more the website is explored the more articles are likely to be seen twice within the same session. It will soon end up into a suggestion loop that it will recursively shows the same contents; recursive structures are popular in newspaper-type websites. Online Retailers as Amazon, based on filters, groups inside a single webpage (i.e. page n° 1) a fixed set of items, having their dedicated personal url attached to them. Furthermore Amazon offers the opportunity to skip to the following page (i.e. page n° 2), searching for another different and fixed set of items and so on until the last page/url. Generally website structures try to reflect both the user expectations with respect to the product on the website and the design expression of the web developer. For these reasons for each websites usage category exists a multitude of content architectures. For each content architectures there are multiple front end languages which are destinated to multiple end users. In the future expectations are tailor made webpages on users with respect to its personal preferences. Moreover web design in scraping plays an important role since the more sophisticated graphical technologies are implied, the harder will be to scrape information. 

![general website structure](images/content-vs-html-title.png)

A _second dimension_ of hierarchy is brought by content architecture in the name of the language used for content creation and organization i.e. HTML. HTML stands for Hyper Text Markup Language and ... 
HTML drives the hierarchy structure that is then generalized to the website structure. According to this point of view the hierarchical website structure is a consequence of the content architecture by means of HTML language ( _arborescence_: direction from root to leaves).
CSS language stands for Cascading Style Sheets and takes care of the style of the webpage. The combination of HTML and CSS offers a wide flexibility in building web sites, once again expressed by the vast amount of different designs on the web. Some websites' components also might be tuned by Javascript language, which in the context of scraping adds a further layer of difficulty. As a matter of fact since Javascript components are dynamic within the webpage, scraping requires specialized libraries to enable different parser to get the content. CSS allows the scraper to target a class of objects in the web page that shares same style (e.g. same css query) so that each element that belongs to the class (i.e. share same style) can be gathered. This practice provides enormous advantages since by CSS a set of objects can be obtained within a single function call. 
First and Second dimension of the scraping problem imply hierarchy, a simple way to approach the problem is to represent it through already known data structures. One way to imagine hierarchy in both of the two dimensions are graph based data structures named as **Rooted Trees**. By analyzing the first dimension through the lenses of Rooted trees it is possible to compress the whole problem into the general graph based jargon [@Graph_Diestel]. Rooted trees must start with a root node which is the domain of the web page. Each _Node_ is a url destination and each _Edge_ is the connection between nodes. Connections have been made possible in the website by nesting urls inside webpages so that within a single webpage the user can access to a number of other related links. Furthermore, as an extension to the rooted tree framework a general graph theory component is introduced, i.e. the _Weight_. Each edge is associated to a weight whose interpretation is the run time cost to walk from a node to its conncted other nodes (e.g. from a url to the other). In addition the content inside each node takes the name of payload, which ultimately is the scope of the scraping processes. The walk from node 17 to node 8 in figure below (even though that is the case of a binary rooted tree) is called path and it represented as an ordered list of nodes connected by edges. In this context each node can have both a fixed and variable outgoing sub-nodes that are called _Children_ . When root trees have a fixed set of children are called _k-ary_ rooted trees. A node is said to be _Parent_ to other nodes when it is connected to them by outgoing edge, in right figure below "head" is the parent of nodes "title" and "meta". Nodes in the tree that shares the same parent node are said _Siblings_, "head" and "body" are siblings in figure \@ref(tree_html). Moreover _Subtrees_ are a set of nodes and edges comprised of a parent and its descendants e.g. node "body" with all of its descendants might constitute a subtree. The concept of subtree in both of the dimensions plays crucial role in cutting run time scraping processes and fake headers provision (see section \@ref(spoofing)). If the website strucuture is locally reproducible and the content architecture within webpages tends to be equal, then functions for a single subtree might be extended to the rest of others subtrees that are siblings to the same parent node. Local reproducibility is a property according to which starting from a single url all the related urls can be inferred from a pattern. Equal content architecture throughout different single links means to have sort of standard shared-within advs criteria that each single rental advertisement has to refer. In addition two more metrics have might better describe the tree: _level_ and _height_. The level of a node $\mathbf{L}$ counts the number of edges on the path from the root node to $\mathbf{L}$. The height is the maximum level for any node in the tree, from now on $\mathbf{H}$. What is worth to be anticipating is that functions are not going to be applied directly to siblings in the more general rooted tree. Instead it would be better segmenting the highest level rooted tree into a sequence of single subtrees whose roots are the siblings for reasons explained in section \@ref(spoofing).

![html_tree](images/tree_html.PNG)

###  Immobiliare.it Webscraping website structure{#webstructure}

The structure of the website resembles the one from the popular online retailer Amazon. According to the query filters selected in a dedicated section (e.g. city, number of rooms 5, square footage less than 60 $m^2$ etc), the url is shaped so that each further filter is appended at the end of the domain url `https://www.immobiliare.it/` root node. Filters are appended to the domain with a proper syntax, not all the syntax are equal. Once filters are all applied to the root domain this constitutes the new url root domain node that might have this appearance by filtering for rents in Milan city when square footage is less than 60 $m^2$: domain +`affitto-case/milano/?superficieMinima=60`.  Since this is true only for page n°1 containing the first 25 advs (see figure \@ref(fig:website_tree1)) all the remaining siblings nodes corresponding to the subsequent pages have to be generated. Here the utility of Local reproducibility property introduced in the previous section. The remaining siblings, i.e. the ones belonging to page 2 (with the attached 25 links),to page 3 etc. can be generated by adding a further filter `&pag=n`, where n is the page number reference (from now on referred as _pagination_). Author customary choice is to stop pagination up to 300 pages since spatial data can not be to too large due to computational constraints.
Up to this process pagination has generated a list of siblings nodes whose children elements number is fixed (i.e. 25 links per page \@ref(fig:website_tree1) lower part). That makes those trees _k-ary_, where k is 25 indicating the number of children leaves. K-ary trees are rooted trees in which each node has no more than k children, in this particular case final leaves. The well known binary rooted tree is actually a special case of k-ary when $k = 2$. Filters reverse engineering process and 25-ary trees with equal content structure across siblings allow to design a single function to call that could be mapped for all the other siblings. In addition in order to further unroll the website a specific scraping function grabs the whole set of 25 links per page. As a result a single function call of `scrape_href()` can grab the links corresponding to page 1. Then the function is mapped for all the generated siblings nodes (i.e. up to  300) obtaining a collection of all links belonging to the set of pages. Ultimately the complete set of links corresponds to every single advertisement posted on immobilaire.it at a given time.

![immobiliare.it website structure, author source](images/website_tree1.jpg){#fig:website_tree1}


### Immobiliare.it Webscraping content architecture with `rvest`{#ContentArchitecture}

To start a general scraping function the only requirement is a target url (i.e. the filtered root node url). Then a list `html_session` object is opened by specifying the url and  the request data that the user need to send to the web server (see left part to dashed line image \@ref(fig:workflow)). Information to be attached to the web server request will be further explored later, tough they are mainly three: User Agents, emails references and proxy servers. `html_session` objects contains a number of useful information such as: the url, the response, coockies, session times etc. Once the connection is established (request response 200) all the following operations rely on the opened session, in other words for the time being in the session the user will be authorized with the before-provided characteristics through the request.
The list object contains mostly the html content of the webpage and that is where data needs to be parsed. The list can disclose as well other interesting meta information related to the session but they are not collected.
The figure in \@ref(fig:rvest flow chart, missing source) sketches what the scraping needs to front:

![rvest flow chart, missing source](images/workflow.png){#fig:workflow}

To the right of dashed line in the flow chart are painted a sequence of `rvest`[@rvest] functions that follow a general step by step text comprehension rules. `rvest` first handles parsing the html content of the web page within the session object `read_html()`, secondly It looks for a single node `html_nodes()` through a CSS query. CSS is a way to route `rvest` to consider a precise node in the webpage. Thirdly it converts the content (i.e. payload) into a human readable text with `html_text()`. The sketch of immboliare.it content strucures is reported in the figure below:

![immobiliare.it content structure, author's source](images/content_structure.jpg)


The code chunk below shows a function that can scrape the price.


```r
scrapeprice.imm = function(session) {
    
    opensess = read_html(session)
    price = opensess %>% html_nodes(css = ".im-mainFeatures__title") %>% html_text() %>% 
        str_trim()
    
    if (is.null(price) || identical(price, character(0))) {
        price2 = opensess %>% html_nodes(css = ".im-features__value , .im-features__title") %>% 
            html_text() %>% str_trim()
        
        if ("prezzo" %in% price2) {
            pos = match("prezzo", price2)
            return(price2[pos + 1]) %>% str_replace_all(c(`\200` = "", `\\.` = "")) %>% 
                str_extract("\\-*\\d+\\.*\\d*") %>% str_replace_na() %>% str_replace("NA", 
                "Prezzo Su Richiesta")
        } else {
            return(NA_character_)
        }
    } else {
        return(price) %>% str_replace_all(c(`\200` = "", `\\.` = "")) %>% str_extract("\\-*\\d+\\.*\\d*") %>% 
            str_replace_na() %>% str_replace("NA", "Prezzo Su Richiesta")
        
    }
    
}
```

The function takes as a single argument a session object which is at first initialized in one other function. Then It reads the inner html content in the session storing the information into an obj called the `opensess`. Another obj is created, namely price, right after the pipe operator a css query into the html is called. The css query `.im-mainFeatures__title` points to a precise data location inside the web page, right below the main title. Expectation are that price is a one-element chr vector, containing the price and other unnecessary non-UTF characters. Then the algorithm enters into the first `if` statement. The handler checks if the object `price` is empty. If it doesn't the algorithm jumps to the end of the algorithm and returns the cleaned quantity. But If it does it takes again the `opensess` and tries with a second css query `.im-features__value , .im-features__title` where price might be also found. Please note that this is all done within the same session, so no more additional request information has to be sent. Since the latter css query points to data stored inside a list, for the time being the newly created obj price2 is a list containing various information. Then the algorithm flow enters into the second `if` statement that checks whether the `"prezzo"` is matched the list or not, if it does it returns the +1 position index element with respect to the "prezzo" positioning. This happens because data in price2 list are stored by couples sequentially, e.g. [title, "Appartamento Sempione", energy class, "G", "prezzo", 1200/al mese]. When it returns the element corresponding to +1 position index it applies also some data wrangling with `stringr` package to keep out overabundant characters. The function then escapes in the else statement by setting `price2 = NA_Character_` once no css query could be finding the price information. the _character-string_ type has to be imposed due to fact that later they can not be bind. In other words if the function is evaluated for a url and returns the price quantity, but then is evaluated for url2 and outputs NA (no character) then results can not be combined into dataframe due to different types.


Once all the functions have been created they need to be called together and then data coming after them need to be combined. This is done by `get,data.catsing()` which at first checks the validity of the url, then takes the same url as input and filters it as a session object. Then simultaneously all the functions are called and then combined. All this happens inside a `foreach` parallel loop called by `scrape.all.info()` 



```r
scrape.all.info = function(url = "https://www.immobiliare.it/affitto-case...",
                           vedi = FALSE, 
                           scrivi = FALSE, 
                           silent = FALSE){
  if (silent) {
    start = as_hms(Sys.time()); cat('Starting the process...\n\n')
    message('\nThe process has started in',format(start,usetz = TRUE))  
  }
  # open parallel multisession
  cl = makeCluster(detectCores()-1) #using max cores - 1 for parallel processing
  registerDoParallel(cl)
  start = as_hms(Sys.time())
  
  if (silent) {
    message('\n\nStart all the requests at time:', format(start,usetz = T))  
  }
  ALL = foreach(i = seq_along(links),
                .packages = lista.pacchetti,
                .combine = "bind_rows",
                .multicombine = FALSE,
                .export ="links" ,
                .verbose = TRUE,
                .errorhandling='pass') %dopar% {
                  source("utils.R")
                  sourceEntireFolder("functions_singolourl")
                  get.data.catsing = function(singolourl){
                    
                    # dormi()
                    # 
                    if(!is_url(singolourl)){
                      stop(paste0("The following url does not seem either to exist or it is invalid", singolourl))
                    }
                    
                    session = html_session(singolourl, user_agent(agents[sample(1)]))
                    if (class(session) == "session") {
                      session = session$response  
                    }
                      
                    id         = tryCatch({scrapehouse.ID(session)},
                                          error = function(e){ message("some problem occured in scrapehouse.ID") })
                    lat        = tryCatch({scrapelat.imm(session)},
                                          error = function(e){ message("some problem occured in scrapelat.imm") })
                    long       = tryCatch({scrapelong.imm(session)},
                                          error = function(e){ message("some problem occured in scrapelong.imm") })
                    location   = tryCatch({take.address(session)},
                                          error = function(e){ message("some problem occured in take.address") })
                    condom     = tryCatch({scrapecondom.imm(session)},
                                          error = function(e){ message("some problem occured in scrapecondom.imm") })
                    buildage   = tryCatch({scrapeagebuild.imm(session)},
                                          error = function(e){ message("some problem occured in scrapeagebuild.imm") })
                    
                  ...
                  
                   combine = tibble(ID        = id,
                                     LAT       = lat, 
                                     LONG      = long,
                                     LOCATION  = location,
                                     CONDOM    = condom,
                                     BUILDAGE  = buildage,
                                    
                  ...
                  
                  
                  return(combine) 
                  }
  stopCluster(cl)
  return(ALL)
}
```

The skeleton constitutes a standard format adopted for many other scraping function in the analysis. Being equal the css query what it changes is the matching term, i.e. "numero camere" instead of "prezzo" to look for how many rooms there are in the house. This is true for all the information contained in the list accessed by the fixed css query. Those that are not they are a few and they do not need to be scraped. 
In addition some other functions outputs need to undergo to further heavy cleaning steps in order to be usable As a consequence oh that functions need also to be broken down by pieces into many single .R files whose names correspond to each important information.
Below it is printed the tree structure folder that composes the main elements of the scraping procedure. It can be notices that the two folders, namely functions_singolourl and functions_url enclose all the single functions that allows to grab single information from session. Folders with a customized function are then sourced within the two main functions, scrape.all and scrape.all.info so data can be extracted.

```
 levelName
1  immobiliare.it-WebScraping     
2   ¦--functions_singolourl       
3   ¦   ¦--0scrapesqfeetINS.R     
4   ¦   ¦--0scrapenroomINS.R      
5   ¦   ¦--0scrapepriceINS.R      
6   ¦   ¦--0scrapetitleINS.R      
7   ¦   ¦--ScrapeAdDate.R         
8   ¦   ¦--ScrapeAge.R            
9   ¦   ¦--ScrapeAgeBuilding.R    
10  ¦   ¦--ScrapeAirConditioning.R
11  ¦   ¦--ScrapeAptChar.R        
12  ¦   ¦--ScrapeCatastInfo.R     
13  ¦   ¦--ScrapeCompart.R        
14  ¦   ¦--ScrapeCondom.R         
15  ¦   ¦--ScrapeContr.R          
16  ¦   ¦--ScrapeDisp.R           
17  ¦   ¦--ScrapeEnClass.R        
18  ¦   ¦--ScrapeFloor.R          
19  ¦   ¦--ScrapeHasMulti.R       
20  ¦   ¦--ScrapeHeating.R        
21  ¦   ¦--ScrapeHouseID.R        
22  ¦   ¦--ScrapeHouseTxtDes.R    
23  ¦   ¦--ScrapeLAT.R            
24  ¦   ¦--ScrapeLONG.R           
25  ¦   ¦--ScrapeLoweredPrice.R   
26  ¦   ¦--ScrapeMetrature.R      
27  ¦   ¦--ScrapePhotosNum.R      
28  ¦   ¦--ScrapePostAuto.R       
29  ¦   ¦--ScrapePropType.R       
30  ¦   ¦--ScrapeReaReview.R      
31  ¦   ¦--ScrapeStatus.R         
32  ¦   ¦--ScrapeTotPiani.R       
33  ¦   ¦--ScrapeType.R           
34  ¦   °--take_location.R        
35  ¦--scrapeALL.R                
36  ¦--scrapeALLINFO.R            
37  ¦--functions_url              
38  ¦   ¦--ScrapeHREF.R           
39  ¦   ¦--ScrapePrice.R          
40  ¦   ¦--ScrapePrimaryKey.R     
41  ¦   ¦--ScrapeRooms.R          
42  ¦   ¦--ScrapeSpace.R          
43  ¦   °--ScrapeTitle.R          
44  ¦--libs.R                     
45  ¦--utils.R                    
46  ¦--README.Rmd                 
47  ¦--README.md                  
48  °--simulations                
49      ¦--rt_match_vs_forloop.R  
50      °--runtime_simul.R
```



##  Scraping Best Practices and Security provisions{#best-practices}

Robots.txt files are (rivedi citation) a way to kindly ask webbots, spiders, crawlers, wanderers and the like to access or not access certain parts of a webpage. The de facto ‘standard’ never made it beyond a informal “Network Working Group INTERNET DRAFT”. Nonetheless, the use of robots.txt files is widespread (e.g. https://en.wikipedia.org/robots.txt, https://www.google.com/robots.txt) and bots from Google, Yahoo and the like will adhere to the rules defined in robots.txt files, although their _interpretation_ of those rules might differ.

Robots.txt files are plain text and always found at the root of a website's domain. The syntax of the files in essence follows a fieldname: value scheme with optional preceding user-agent: ... lines to indicate the scope of the following rule block. Blocks are separated by blank lines and the omission of a user-agent field (which directly corresponds to the HTTP user-agent field) is seen as referring to all bots. # serves to comment lines and parts of lines. Everything after # until the end of line is regarded a comment. Possible field names are: user-agent, disallow, allow, crawl-delay, sitemap, and host. For further notions [@robotstxt, @google:robottxt]

Some interpretation problems:

- finding no robots.txt file at the server (e.g. HTTP status code 404) implies that everything is permitted
- subdomains should have there own robots.txt file if not it is assumed that everything is allowed
- redirects involving protocol changes - e.g. upgrading from http to https - are followed and considered no domain or subdomain change - so whatever is found at the end of the redirect is considered to be the - robots.txt file for the original domain
- redirects from subdomain www to the doamin is considered no domain change - so whatever is found at the end of the redirect is considered to be the robots.txt file for the subdomain originally requested

For the thesis purposes it has been designed a dedicated function to assess whether the domain or the related paths require specific actions or they prevent some activity on the target. The following `checkpermission()` function has been integrated inside the scraping system and it is called once at the starting point.


```r
dominio = "immobiliare.it"

checkpermission = function(dom) {
    
    robot = robotstxt(domain = dom)
    vd = robot$check()[1]
    if (vd) {
        cat("\nrobot.txt for", dom, "is okay with scraping!")
    } else {
        cat("\nrobot.txt does not like what you're doing")
        stop()
    }
}
## metti path allowed check
checkpermission(dominio)
```

```
## 
## robot.txt for immobiliare.it is okay with scraping!
```


Further improvements in this direction might come with the `polite` package [@polite] which combines the power of the `robotstxt`, the `ratelimitr` [@ratelimitr] to limit sequential requests together with the `memoise` [@memoise] for response caching. This package is wrapped up around 3 simple but effective ideas: 

> The three pillars of a polite session are seeking permission, taking slowly and never asking twice.

The three pillars constitute the _Ethical_ web scraping manifesto [@densmore_2019] which are common shared practises that are aimed to self regularize scrapers. These have to be intended as best practices, not in any case as law enforcements, however many scrapers themselves, as website administrators or analyst, have fought in their daily working tasks with bots. Crawling bots in intensive scraping processes might fake real client navigation logs and as a consequence might induce distorted analytics. Due to this fact comes the need to find a common operating ground and therefore politely asking for permission.

## Security provisions: User Agents, Proxies and Handlers 

HTTP requests to the website server by web clients come with some mandatory information packed in it. The process according to which HTTP protocols allow to exchange information can be easily thought with an  everyday real world analogy. As a generic person A rings the door's bell of person B's house. A comes to B door with its personal information, its name, surname, where he lives etc. At this point B may either answer to A requests by opening the door and let him enter given the set of information he has, or it may not since B is not sure of the real intentions of A. This typical everyday situation in nothing more what happens billions of times on the internet everyday, the user (in the example above A) is interacting with a server website (part B) sending packets of information. If a server does not trust the information provided by the user, if the requests are too many, if the requests seems to be scheduled due to fixed sleeping time, a server can block requests. In certain cases it can even forbid the user log to the website. The language the two parties exchanges are coded in numbers that ranges from 100 to 511, each of which has its own specific significance. A popular case of this type of interaction occurs when users are not connected to internet so the server responds 404, page not found. Servers are built with a immune-system like software that raises barriers and block users to prevent dossing or other illegal practices.

![How Web Works](images/how_web_works.png)

This procedure is a dayly issue to people that are trying to collect information from websites. Google performs it everyday with its spider crawlers, which are very sophisticated bots that scrapes over a enormous range of websites. This challenge can be addressed in multiple ways, there are some specific Python packages that overcome this issue. The are also certain types of scraping as the Selenium web driver automation that simulates browser automation. Selenium allows the user not to be easily detected by the server immune system and peaceful. Precautions have not been taken lightly, and a simple but effective approach is proposed.

### User Agents Spoofing{#spoofing}

A user agent [@whoishostingthis.com] is a string of characters in each web browser that serves as identification card. The user agent permits the web server to be able to identify the user operating system and the browser. Then, the web server uses the exchanged information to determine what content should be presented to particular operating systems and web browsers on a series of devices. The user agent string includes the user application or software, the operating system (and their versions), the web client, the web client’s version, as well as the web engine responsible for the content display (such as AppleWebKit). The user agent string is sent in the form of a HTTP request header. Since User Agents acts as middle man between the client request and the server response, then from a continous scraping point of view it would be better rotating them, so that each time the middle man looks different. The solution adopted builds a vector of user agent strings identified by different specifications, different web client, different operating system and so on, then samples 1 of them 
Then whenever a request from a web browser is sent to a web server, 1 random sample string is drawn from the user agents pool. So each time the user is sending the request it appears to be a different User Agent.
Below the user agents rotation pool:


```r
set.seed(27)
agents = c("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36", 
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14", 
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36", 
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36", 
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36", 
    "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0")
agents[sample(1)]
```

```
## [1] "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
```

A more secure approach might be a further rotation of proxies between the back and forth sending-receving process. A proxy server acts as a gateway between the web user and the web server.
While the user is exploiting a proxy server, internet traffic flows through the proxy server on its way to the server requested. The request then comes back through that same proxy server and then the proxy server forwards the data received from the website back to the client. The final result will be linear combination of User Agents ID and Proxy server for each sending requests, grating a high security level.
Many proxy servers are offered in a paid version, so in this case since security barriers are not that high they  will not be implemented. As a further disclaimer many online services are providing free proxies server access, but this comes at a personal security cost due to a couple of reasons:
- Free plan Proxies are shared among a number of different clients, so as long as someone has used them in the past for illegal purposes the client is indirectly inheriting their legal infringements.
- Very cheap proxies, for sure all of the ones free, have the activity redirected on their servers monitored, profiling in some cases a user privacy violation issue.

### Handlers and Trycatches

During scraping many difficulties are met. Some of them might come from website structure issues, so that rooted-tree hierarchies are changed as a consequence of a restructuring. Some others might interest content architecture where data is reallocated to some other places in the webpage, then CSS query are no more able to catch data. Handlers in the form of trycatch error workarounds are explicitly built in this sense. The continuous building and testing of the scraping functioning has required the maintainer to have a precise and fast debugging experience. The following consideration might give a sense of the time consumed when debugging handlers are not implied: `get.data.catsing()` triggers 34 different scrapping functions that are supposed to point to 34 different data pieces. Within a single function call by default pagination generates 10 pages each of which contains at least 25 different single urls to be scrapped. That leads to a number of 8500 single data information, the probability given 8500 associated to something going missing or misparsed is undoubtedly high.
The solution proposed tries to handle fails by implementing as many trycatches as scrapping fucntions inside the a the single `get.data.catsing()` call. Then inside each single scrapping function are put the handlers. This set up allows to catch (and in some cases prevent) fails starting from the very end of the scraping process. As a consequence of this setting when a scrapping function is not able to gather data an error inside the function is thrown, then the error call is intercepted by the corresponding trycatch, which at the end messages where the error occurs.
Below some of the main handlers implied:

- `.get_ua()` verifies that the User Agent in the session is not the default one.


```r
.get_ua = function(sess) {
    stopifnot(is.session(sess))
    stopifnot(is_url(sess$url))
    ua = sess$response$request$options$useragent
    return(ua)
}
```


- `.is_url()` verifies that the url input needed has the canonic form. This is done by a REGEX query.


```r
.is_url = function(url) {
    re = "^(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9¡-<ef><U+00BF><U+00BF>](?:-)*)*(?:[a-z0-9¡-<ef><U+00BF><U+00BF>])+)(?:\\.(?:[a-z0-9¡-<ef><U+00BF><U+00BF>](?:-)*)*(?:[a-z0-9¡-<ef><U+00BF><U+00BF>])+)*(?:\\.(?:[a-z0-9¡-<ef><U+00BF><U+00BF>]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?$"
    grepl(re, url)
}
```



- `.get_delay()` checks through the robotxt file if a delay between each request is kindly welcomed. When response is NA delay is not required.


```r
.get_delay = function(domain) {
  
  message(sprintf("Refreshing robots.txt data for %s...", domain))
  
  cd_tmp = robotstxt::robotstxt(domain)$crawl_delay
  
  if (length(cd_tmp) > 0) {
    star = dplyr::filter(cd_tmp, useragent=="*")
    if (nrow(star) == 0) star = cd_tmp[1,]
    as.numeric(star$value[1])
  } else {
    10L
  }
  
}
get_delay =  memoise::memoise(.get_delay) ## so that .get_delay results are cached
.get_delay(domain = dominio)
```

```
## [1] NA
```

## Parallel Computing

Since are opened as many sessions as single links and since for each link are supposed to be called 34 functions run time computation can take a while. Run time is crucial when dealing with active web pages and time to market in real estate is very important, in here originates the need to have always up-to-date data. Run time optimization involves each level of the scraping process from the "lowest" i.e. inside each single function to the "highest" i.e. the agglomerative function. Inside single scraping functions as a general criteria for loops are avoided due to Rcpp reasons, vectorization is preferred. Within agglomerative function instead the approach was to test two different results. All the following runtime examinations are performed on the `scrape()` functions which is a lightweight version of the final API function. 
The first attempt was using `furrr` package [@furrr] which enables mapping through a list with the `purrr`, along with a `future` parallel back end. The approach has shown decent preformance, but its run time drastically increases when more requests are sent. This leads to a preventive conclusion about the computational complexity: it has to be at least linear with steep slope. Empirical demonstrations have been made:






![computational complexity analysis with Furrr](images/run_timefurrr.png)


On the x-axis in the figure the number of urls which are evaluated together, on y axis the run time taken measured in seconds. Iteration after iteration the urls considered are cumulated one at at a time. Looking at the blue smoothing curve in between confidence lines the big-O guess might be linear time $\mathcal{O}(n)$, where n are the links considered.

A second attempt tried to explore the `foreach` package [@foreach]. This quite recent package enables a new looping construct for executing R code in an iterative way. The core reason for using the `foreach` package is that it supports *parallel execution*, that is, it can execute those repeated operations on multiple processors/cores on the computer, or on multiple nodes of a cluster. The construction follows the r-base looping idea, below steps are summarized:

- start clusters on processors cores
- define the iterator, i.e. "i"  equal to the number of elements that are going to be looped
- `.packages`: Inherits the packages that are used in the tasks define below
- `.combine`: Define the combining function that bind results at the end (say cbind, rbind or tidyverse::bind_rows).
- `.errorhandling`: specifies how a task evaluation error should be handle.
- `%dopar%`: the dopar keyword suggests foreach with parallelization method
- then the function within the elements are iterated
- close clusters

One major concern regards that functions inside the %dopar% should be standalone in order to be executed in parallel. For standalone it is meant that everything that is needed to be executed and to output results should be defined inside the  %dopar%, as it would be opened a new empty environment for each iteration. Moreover as a further consequence packages imported into each clusters, the .packages methods takes care of that.





![computational complexity analysis with Furrr](images/run_timeforeach.png)

It can be grasped quite easily that the curve now is flattened and a confident guess migh be logarithmic time $\mathcal{O}(log(n))$. 

A further performance improvement could be obtained using a new package called `doAzureParallel` which is built on top of the foreach. doAzureParallel enables different Virtual Machines operating parallel computing throughout Microsoft Azure cloud, but this comes at a substantial monetary cost. This would be a perfect match given that parallel methods seen before accelerates the number of requests sent among different processors or cluster, even though actually the goal is to have something that separates different sessions. Unleashing Virtual Machines allows from one hand to further increase computational capabilties, so the number of potential requests, from the other it can partition requests among different proper machines (a pool of agents for each VM) extending even more the combination of IDs and as a consequence masquerading even better the scraping automation.


## Open Challenges{#challenges}

The main challenge remains unsolved since each single elements have been finely optimized but scraping function and so REST API must be continuously maintained.   Indeed What it can not be a-priori optimized are the future changes that involves the website structure. Content architecture as opposite, with some sophistication can take care of finding exact information within the webpage even if the designed is changed. The idea developed in the package @Rcrawler, even though results are not always acceptable, is to crawl the website and to search for targeted keywords. Once keywords are found the scraping algorithm looks for the related information that should be located throughout the html files locally stored. html are known to be very lightweight so computation of this kind is not bothering run time. For this reasons performances with algorithm of this species are very neat but results, as anticipated, are under the expectation. As a solution an accurate text mining approach can be considered as a further enachement. It should be also pointed out that @Rcrawler is designed to scrape a vast number of websites, as contrary the scraping functions here presented are exclusively designed to be applied on immobliare.it, even though they can be extended to other related website with no effort.
The way the scraping function are designed really facilitates responsive fast debugging but this can not be by any means automatized. The API necessitates frequently to resort to continuous integration (i.e. CI) review to verify the working status. Moreover Error messages can not really be understood sometimes even with handlers, this is due to functions that are called within a parallel beckend that does not allow to print error on console as in this  [stackoverflow reproducible example](https://stackoverflow.com/questions/10903787/how-can-i-print-when-using-dopar). So each time an error occurs the "main" functions needs to be taken out of from the parallel back end and separately evaluated. This is time consuming but for the time being no solutions have been found. 

## Legal Profiles (ancora non validato)

"Data that is online and public is always available for all" is never a good answer to the question "Can I use those web data to my scope". [Immobiliare.it](https://www.immobiliare.it/) is not providing any open source data from its own database neither the perception is that it is planning to do so in the future. Immobiliare has not even provided a paid API through which data might be accessed.
A careful reading of their terms, reviewed with a intellectual property expert, has been done to get this service running without any legal consequence, as a reference the full policy can be seen in their [specialized section](https://www.immobiliare.it/terms/). Nevertheless the golden standard for scraping was respected since the robottxt is neat allowing any actions as demonstrated above. So if it might be the case of misinterpretation of their policy, it will be also the case of lack of communication between servers response and immobiliare.it intent to preserve their own intellectual property.
What it was shockingly surprising are the low barriers to obtain information with respect to other counterpart online players. Best practices are applied and delayed requests (even though not asked) have been sent to normalize traffic congestion. But scraping criteria followed are once again fully based on common shared best practises (see section \@ref(best-practices)), and *not* any sort of general agreements between parties. As a result a plausible approach could be applying scraping procedures without any prevention. It would not surely cause any sort of disservice for the website since budjet constraints are set low, but in the long run it will cause lagging as soon as budjet or subjects will increase. Totally different was the approach proposed by Idealista.com, which is a comparable to immobiliare.it. Idealista does block requests if they are not in compliance with their servers inner rules. User agents in this case must be rotated quite frequently and as soon as a request does not fall within the pool of user agents (i.e. is labled as web bot) it is immediately blocked and 404 response is sent back. Delay is kindly asked and it must be specified, consequnetly this slows down scraping function per se.

- Idealista content is composed by Javascript so and html parser can no get that.
- Idealista blocks also certain web browser that have a demonstrated "career" in scraping procedures.

All of this leads to accept that entry barriers to scrape are for sure higher than the one faced for Immobiliare. The reticence to share data could be a reflex on how big idealista is; as a matter of fact it has a heavy market presence in some of the Europe real estate country as Spain and France. So the hidden intention was to raise awareness on scraping procedure that in a certain remote way can hurt their business. This has been validated by the fact that prior filtering houses on their website a checkbox has to be signed. The checkbox make the user sign an agreement on their platform according to which data can not be misused and it belongs their intellectual property.








