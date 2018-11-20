### Rails Security Policy

All Threespot Rails applications are expected to adhere to this policy.

### Stewardship and CVE Responses

If you are the backend developer for a build, you are responsible for responding to security incidents for the live application. You are also responsible for maintaining an active codebase (i.e. you cannot archive it off of GitHub).

You should subscribe to the [CVE mailing list for Rails][listserv] and you should act immediately to update Rails if a CVE is announced that affects your version. The steps are usually as follows:

1. Read the CVE and become familiar with the urgency of the problem
2. Run `bundle update rails` in your project folder to update only the Rails gem
3. Run your test suite to check that you didn't break anything
4. Commit and push

If this update work happens while a jobcode is live, bill it to that jobcode. Otherwise, bill this time to “Technology In-house — General In-house” with a note about what you did. Threespot has built the cost of this time into your original project.

This security-only maintenance will continue until one of the following scenarios occur:

1. **The project is sunset to make way for a replacement project.** Ensure all live copies of the application are correctly shut down and can’t be accessed on the public internet.

2. **The client requests to become the primary steward of the codebase.** In this case, you should transfer the codebase to them (usually on GitHub) and absolve yourself of the ability to see or act on fixes for it (usually by leaving the remote project and giving up commit and viewing access). This removes your risk of being negligent about security issues. You should be clear with the client that you are passing on this responsibility to their team.

3. **The client makes changes to the codebase that Threespot finds to have impeded our ability to quickly mitigate security vulnerabilities.** You need to contact your account person to immediately discuss either resolving this problem, or transferring the application to the client's stewardship (see #2).

4. **The Ruby on Rails core team team announces that the client's version of Ruby on Rails will no longer be receiving security patches (usually due to age).** In this case, you should contact your appropriate account person to discuss offering the client a project to upgrade their Rails application or transferring stewardship to the client (see #2).

To limit Threespot’s liability as well as that of the client, work should not continue until known vulnerabilities are fixed.

[listserv]: https://groups.google.com/forum/#!forum/rubyonrails-security

### OpenSSL

Update your local OpenSSL installation if OpenSSL issues are disclosed that affect OpenSSL clients. The steps are usually:

1. Install the updated OpenSSL with Homebrew.
2. Uninstall and re-install all relevant versions of Ruby so that they compile with the new OpenSSL version.
3. Uninstall and re-install Postgres.app (it comes with a version of OpenSSL bundled)

Issues with Ruby's internal OpenSSL are very frustrating sometimes, but you must resist disabling OpenSSL security features. Never set `OpenSSL::SSL::VERIFY_NONE ` (or variants) in your Ruby code. Fix the underlying problem instead.

Never change the first line of the `Gemfile` to fetch gems over unsecured HTTP. Only install gems over a secure channel. In addition to ensuring that these gems are not modified in transit, this also checks that you are legitimately connecting to `rubygems.org`.

### HTTPS, TLS, and SSL

By default, this app is configured to serve the production environment only over HTTPS and publish a HSTS header. In addition, session cookies are set to be unreadable by JavaScript and served securely. Do not change these settings without a very legitimate reason (and usually a client discussion). The entire site should be HTTPS-only.

During development deployments, Heroku provides the `*.herokuapp.com` subdomain over TLS. In production, you must use the [SSL Endpoint][ssl-endpoint] add-on and serve a certificate purchased by the client. We like [RapidSSL Online][rapidssl]. Recommend a three-year certificate. Store all artifacts from the certificate process in the `Technology → Certificates` folder on Box.

Backend and front-end developers must work together to squash mixed-content issues on the site. Third party plugins and iframes that do not work correctly over HTTPS-only must be rejected. All JavaScript, images, and stylesheets must be fetched over HTTPS for the project. Use only secure URLs to Amazon S3, and only use CDNs that allow SSL paths.

On Heroku, the site will usually run on the `www` subdomain. The apex domain's `A` record should point to a redirector application that 301 redirects everyone to the `https://www` version of the site. Almost all domain name companies provide this service (it’s sometimes called "domain forwarding" or "domain redirects").

[ssl-endpoint]: https://devcenter.heroku.com/articles/ssl-endpoint
[rapidssl]: https://www.rapidsslonline.com/rapidssl-certificates.aspx
