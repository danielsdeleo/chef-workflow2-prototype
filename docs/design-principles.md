AGREE:

1. treat chef server as artifact server
   everything is an artifact you can pin
   separate node desired state
   separated desired state is the policy doc
2. need to be able to promote whole policy across stages
3. but also need to be able to promote individual assets
4. Write up how #2 and #3 work.


# Big Picture Stuff

## Development to Deployment ##
We want to maximize the rate at which value is delivered to an
organization via its IT assets. We haven't succeeded until code is in
production. Therefore, we consider making users successful at delivering
cookbooks and other Chef assets all the way from local development to
production a necessary component of the chef workflow project.

## Simplify #
* We want to focus the workflow on the task at hand.
* We want to policy data and changes to be visible.
* We want to simplify the process of moving policy data and changes
  through the infrastructure.

Therefore we want to assemble source components into an artifact that
the user can inspect, diff with previous revisions, test, and deploy
with confidence. The assets that compose the artifact must not be
mutable after it is assembled. 

We want the process of creating and deploying this artifact to involve
the least conceptual overhead possible. We prefer to achieve this by
making the system itself conceptually simple rather than providing a
simplified view of underlying complexity.

Caveat: some deliverance workflows rely on promoting individual assets
(e.g., an updated cookbook) through the various deployment stages. The
proposed design allows for this, by creating a new artifact manifest
document. See below.

# Design

* Environments and Roles as they exist today are not used.
* Nodes no longer have a `run_list` on an individual basis.
* Cookbook version objects have a unique identifier field. Traditional
  x.y.z version numbers continue to exist, but are not used in
  server-side version pinning; unique identifiers are used instead.
* Functionality of environments, roles, and per-node `run_list`s are
  replaced with "node policy" documents, which we also call "artifact
  manifests" in some design documentation. The node policy document
  contains a list of cookbook names with unique identifiers to specify
  the exact set of cookbooks the client will use. The node policy
  document also contains the `run_list` that the client will run, as
  well as attributes (which replace environment and role attributes).
* When `chef-client` runs, it fetches its policy document and all of the
  cookbook versions specified in that document, then runs the `run_list`
  specified in the policy document. There is no `run_list` expansion
  step.
* The exact process by which a node is linked to a policy document is
  not certain. One possibility is that environments will be repurposed
  as namespaces for node policies, so that nodes will request their policy
  documents from the server by environment name and policy document name
  (combined). More concretely, `{"staging", "webserver"}`, `{"staging",
  "memcache"}`, and `{"production", "webserver"}` are all unique policy
  documents. Another option is to create a new concept, called
  "deployment groups" or "cells" as containers for node policies. This
  might be a flat namespace with a naming convention, so that cells will
  typically have names like "appserver-production"


# Key Details

## Treat the Chef Server as an Artifact Server

Wherever possible, we want to remove mutability from the system. In
particular, cookbook objects will have an ID, and it will be forbidden
to modify the cookbook with that given ID. Traditional x.y.z. version
numbers will remain for cases where they are appropriate, but the
pinning mechanism will reference IDs instead of `{name, version}` tuples.

How this applies to objects such as data bags is something we'll need to
spend time figuring out.

## Separate Node Desired and Last Seen State

This proposal fixes most of the problem with node objects containing
both desired and last-observed state. Node "normal" attributes will need
to be handled separately.

## Server Algorithm Sanity

Server operations should not involve NP complexity algorithms and should
use a minimal amount of space. The current dependency solving logic
involves an NP algorithm and uses memory proportional to the total
number of cookbook versions that exist. The solution we propose moves
dependency solving to the client where a user can `CTRL-C` a runaway
computation safely. Each desired cookbook will be fetched by ID which
gives optimal (low) time and space complexity. Obvious implementation
options are to have a single api to fetch a policy document's cookbooks
(similar to what we have now) or to have the client make N api calls.

