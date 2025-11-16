defmodule AshPhoenixStarterWeb.Menu do
  use Gettext, backend: AshPhoenixStarterWeb.Gettext
  use AshPhoenixStarterWeb, :html

  @doc """
  Configure left menu in the application
  """
  def left_menu do
    [
      %{
        title: gettext(""),
        links: [
          %{
            href: ~p"/dashboard",
            icon: "hero-chart-bar-solid",
            text: gettext("Dashboard")
          }
        ]
      },
      %{
        title: gettext("Farm Management"),
        links: [
          %{
            href: ~p"/farms",
            icon: "hero-map-pin",
            text: gettext("Farms")
          },
          %{
            href: ~p"/farms/fields",
            icon: "hero-map",
            text: gettext("Fields")
          },
          %{
            href: ~p"/crops",
            icon: "hero-building-storefront",
            text: gettext("Crops")
          },
          %{
            href: ~p"/farms/planting",
            icon: "hero-shopping-bag",
            text: gettext("Planting")
          },
          %{
            href: ~p"/farms/harvesting",
            icon: "hero-shopping-cart",
            text: gettext("Harvesting")
          },
          %{
            href: ~p"/farms/inputs",
            icon: "hero-squares-2x2",
            text: gettext("Inputs")
          },
          %{
            href: ~p"/farms/inputs",
            icon: "hero-user-group",
            text: gettext("Employees")
          }
        ]
      },
      %{
        title: gettext("Reports"),
        links: [
          %{
            href: ~p"/reports/graphs",
            icon: "hero-chart-pie",
            text: gettext("Graphs")
          },
          %{
            href: ~p"/reports/summaries",
            icon: "hero-bars-3-bottom-left",
            text: gettext("Summary")
          },
          %{
            href: ~p"/reports/details",
            icon: "hero-list-bullet",
            text: gettext("Details")
          }
        ]
      },
      %{
        title: gettext("Accounting"),
        links: [
          %{
            href: ~p"/ledger/transfers",
            icon: "hero-arrows-right-left",
            text: gettext("Journal")
          },
          %{
            href: ~p"/ledger/journal",
            icon: "hero-document-text",
            text: gettext("Genearl Ledger")
          },
          %{
            href: ~p"/ledger/chart-of-accounts",
            icon: "hero-table-cells",
            text: gettext("Chart of Accounts")
          }
        ]
      },
      %{
        title: gettext("Settings"),
        links: [
          %{
            href: ~p"/settings",
            icon: "hero-cog-6-tooth",
            text: gettext("General")
          },
          %{
            href: "/accounts/teams",
            icon: "hero-building-library",
            text: gettext("Teams")
          },
          %{
            href: "/accounts/users",
            icon: "hero-users",
            text: gettext("Users")
          },
          %{
            href: "/accounts/groups",
            icon: "hero-user-group",
            text: gettext("User Groups")
          }
        ]
      }
    ]
  end
end
