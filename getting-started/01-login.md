OpenShift ships with a feature rich web console as well as command line tools
to provide users with a nice interface to work with applications deployed to the
platform. The OpenShift tools are a single executable written in the Go
programming language and is available for Microsoft Windows, Apple OS X and Linux.

In order to login, we will use the `oc` command and then specify the server that we
want to authenticate to:


`oc login https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

You may see the following output:

```
The server uses a certificate signed by an unknown authority.
You can bypass the certificate check, but any data you send to the server could be intercepted by others.
Use insecure connections? (y/n):
```

Enter in `Y` to use a potentially insecure connection.  The reason you received
this message is because we are using a self-signed certificate for this
workshop, but we did not provide you with the CA certificate that was generated
by OpenShift. In a real-world scenario, either OpenShift's certificate would be
signed by a standard CA (eg: Thawte, Verisign, StartSSL, etc.) or signed by a
corporate-standard CA that you already have installed on your system.

Enter the username and password provided to you by the instructor.

Congratulations, you are now authenticated to the OpenShift server. The
OpenShift master includes a built-in OAuth server. Developers and administrators
obtain OAuth access tokens to authenticate themselves to the API. By default
your authorization token will last for 24 hours. There is more information about
the login command and its configuration in the 
[OpenShift Documentation](https://{{DOCS_URL}}/cli_reference/get_started_cli.html#basic-setup-and-login).