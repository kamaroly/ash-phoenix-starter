# Ash Phoenix Application Starter Kit

A starter Kit that helps you build what's unique to your application faster. 

Don't reinvent the wheel for common features. Clone it, rename it and start shipping with confidence today. Build for fast prototype and scaling in the future.

You can find concepts used in this kit in the [Ash Framework for Phoenix Developers](https://medium.com/@lambert.kamaro/ash-framework-for-phoenix-developpers-c29b0a147552) blog serie. I will continue to add features and documentation as time permits. 

![Ash Phoenix Starter Kit](dashboard.png "Starter Kit Dashboard")

## FEATURES

1. Multitenancy with Team Management
2. Team switching
3. User invite to the team
4. Team user group permission management with Ash Policies
5. Permission management
6. Main Menu configurations
7. Chart Reports
8. Map Reports
11. Authentication with Ash Authentication
12. Templating with Daisy UI
14. Accounting with AshDouble Entry

#### Upcoming features

1. Email send out
2. Rich Background Jobs with Oban
3. Impersonation 
4. AI integration with Ash AI
5. Paper trail with Ash Paper Trail
6. Workflows with ash_approver
7. Self referencing data with AshParental
8. Documentations
9. Automated CI/ CD workflow with Github


## Installation 

1. Clone 
2. Rename your project with `mix rename AshPhoenixStarter MyNewProjectName`
3. Replace `AshPhoenixStarter` with `MyNewProjectName` in your javascripts (This will automatically be cattered for in the future
4. Confirm that all is well with `mix tests`
5. Start implementing your new features


To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

### Phoenix
* https://www.phoenixframework.org/
* https://hexdocs.pm/phoenix/overview.html
* Forum: https://elixirforum.com/c/phoenix-forum

### Ash
* https://ash-hq.org/
* https://hexdocs.pm/ash/readme.html
* https://elixirforum.com/c/ash-framework-forum/
