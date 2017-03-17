# Wonderful Collective Coding Challenge

**By Maurice Stephens**

## Problem 1 - Stack 

+ **Hosting** - I've spent the last 2 years working in a Node/Firebase/Angular stack. But in the past, when working with PHP & Symfony, I'd used Chef and Vagrant to build local dev environments. Since then, I've discovered Docker as a much more lightweight tool for local VMs. For Deploying to staging and production Servers we used a tool called Capifony which is a Symfony flavor of Capistrano. As for the hosting environments, I would use AWS and keep a detailed provisioning shell script to set up  environments. For an app of this size (roughly similar to what we used at Minds+Machines) I'd estimate 2 Large RDS instances (one East, one West) and 3 App instances behind a load balancer (all Large, 2 East, one West). I have not had extensive experience setting up these architectures on my own, but worked within a small team of 4 devs - one one which was a dedicated systems guy.

+ **Language & Storage** - This was done with only PHP (using Symfony framework) & Postgres with the Post GIS Extension. Because of the limited time, I did not have time to test the API route with Postman. But if you have Postgres running somewhere in your office, you'll be able to build the database and call the stored function directly form the command line. It Works!

+ **Performance** - I'm guessing there is an index I could add on the country and point fields to optimize the query. I'm not going to go too much further into this since I have not done a ton of it.


## Problem 4 - Get Closest Airports

The most efficient way to deliver the required data, in my estimation, turned out to be using the PostGIS Extension in Postgres since it is already set up to handle geospatial data. This made for minimal PHP programming in the Symfony app itself, just an api controller with an endpoint that simply called a stored function in the database and returned a JSON response. The path to the controller is:
    `src/AppBundle/Controller/Api/GeoController`
Here you can find one stored Potgres method: `getClosestAirportsAction($country1, $country2)`

Everything else is done in the database. Please look in the SQL directory where you'll find a dump of the database (based on the Google Doc spreadsheet of airports). I added a column to each record turning the lat & long values into a POINT with a Geometry datatype. That made it much easier to use the advanced PostGIS ST functions.  

From there I wrote one function which queries for all the airports in both countries passed into the action. It then calculates the min distance between all the members of each set. For the United States and Mexico, the output looks like:

| City1 | City1_Iata | City2   | City2_Iata | Distance |
|-------|------------|---------|------------|----------|
|San Diego |  SDM |    Tijuana |  TIJ |    0.0327719281245385
(1 row)

Given a little more time, I'd convert the Distance value to kilometers.

The SQL call to the database looks like:
`SELECT get_closest_airports(country1, country2);`

That's it. I had never used the PostGIS library before yesterday, but it is a great tool for all things geospatial. My Postgres experience was already strong, but I was happy to find this awesome new tool. 

Now please look in the SQL directory for the database dump. Thank you.