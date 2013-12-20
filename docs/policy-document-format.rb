# Example of a "node policy" or "artifact manifest" or whatever the eventual
# name is.  Obviously the data format will be JSON but I'm using ruby literals
# because comments are nice.
#
# Every node will be tied to exactly one of these. The exact way that a node is
# linked to a node-policy-manifest-thingy could work in a number of ways. One
# of the more obvious ways to link them is by environment, so that a node has:
#
#   Node Config:
#     policy_group_name: erchef_server
#     environment: preprod
#
# Then a node would fetch its policy at a URL like environments/preprod/policy_groups/erchef_server
# or something like that.

np = {
  # It includes a run list. The run list is always expanded (no roles).
  :expanded_run_list => ["cookbook1::recipe1", "cookbook2::recipe2", "..." ],

  # This makes the question of handling the "override run list" feature a
  # little tricky. One thing you could do is put named run lists in here:

  :run_lists => {
    "default" => ["cookbook1::recipe1", "cookbook2::recipe2", "..." ],
    "deploy-code-fast" => ["cookbook2::recipe2"]
  },

  # Every cookbook in the expanded run list, or depended on by one of those
  # recipes is locked:
  :cookbook_locks => {
    # This is the only information you actually need for chef to run:
    "cookbook1" => "78d5778e4c55e0d4efa4697b4171bc86196118f3",

    # But maybe you want to be able to quickly see more info about the
    # cookbook. In that case we can duplicate some information from cookbook
    # metadata. If we don't actually store this in the document, then we'll
    # probably want an API that can _show_ a document like this so humans can
    # look at their policy documents and understand them.
    "cookbook2" => {
      # I'm assuming you'll use cksum-based identifiers, but there's no reason
      # we need to depend on a particular format. If your CD system wants to
      # use UUIDs or anything else it can guarantee is unique, that could be ok, too.
      "identifier" => "168d2102fb11c9617cd8a981166c8adc30a6e915",

      # When using unique identifiers for cookbooks, you need to track
      # "human-usable" information about cookbooks:
      "human_name" => "Apache2 v2.3.5",

      # Didn't put a lot of thought into this yet. URL and whether the repo is
      # "dirty" would be nice to know.
      "scm_ref" => "168d2102fb11c9617cd8a981166c8adc30a6e915"
    }
  },

  # Since you no longer have run-time roles, role attributes go here now:
  :default_attributes => {},
  :override_attributes => {}
}
