# What is CDN

CDN (Content Delivery Network) is an NGINX server that servers content via urls
containing hashes. This makes it save to expose the NGINX server directly to the
internet without concern for robots that are indexing the content files. This CDN
will mount your NFS exports automatically.

#### Configuration

All configuration settings can be found in the .env file. Adjust them to your needs. 

    CDN_SECRET=your_dirty_secret
    NFS_SERVER="addr=192.169.0.1,nolock,soft,ro"
    NFS_EXPORT_MOVIES=":/volume1/Movies"
    NFS_EXPORT_TVSHOWS=":/volume1/TVShows"

#### Build

    docker buildx build --platform=linux/amd64 . -t your-registry/cdn
    docker image push your-registry/cdn

#### RUNNING

Make sure the docker-compose.yml file points to the correct registry (after building and pushing)

    docker-compose up

# Port exposed

The Nginx will run on the non-default port 6001, adjust the docker-compose.yml to your needs.

# Example usage from browser

content is (within the docker container) at:

    '/libraries/movies/Avengers Endgame (2019)/Trailers/-iFq6IcAxBc.mp4'
      
Salt used in hash:

    your_dirty_secret

html encode the content path minus the autofs mount anchor '/libraries/'

    echo -n "movies/Avengers Endgame (2019)/Trailers/-iFq6IcAxBc.mp4" | base64 -
    
The result will be:

    bW92aWVzL0F2ZW5nZXJzIEVuZGdhbWUgKDIwMTkpL1RyYWlsZXJzLy1pRnE2SWNBeEJjLm1wNA===

next append the salt to the base64 encoded result and hash with openssl-md5:

    echo -n "bW92aWVzL0F2ZW5nZXJzIEVuZGdhbWUgKDIwMTkpL1RyYWlsZXJzLy1pRnE2SWNBeEJjLm1wNA==your_dirty_secret" | openssl md5 -hex

This will return the hash:

    (stdin)= e060d2fc4cb9928f019d3dee4231d10c
    
url will now become:

    http://docker-host:6001/media/e060d2fc4cb9928f019d3dee4231d10c/bW92aWVzL0F2ZW5nZXJzIEVuZGdhbWUgKDIwMTkpL1RyYWlsZXJzLy1pRnE2SWNBeEJjLm1wNA==
