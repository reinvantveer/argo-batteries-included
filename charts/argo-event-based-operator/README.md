# The Argo Events-based operator

This is probably why I started this repo in the first place. The use case for this is as follows. After working a few
months with Argo Workflows and when starting to look into Argo Events, it hit me. The idea of writing and maintaining an
operator almost entirely in Kubernetes-native manifests, with some logic handled by a specialized handler. This handler
would be instantiated every time as a workflow to process the event. This wouldn't be the fastest, but it has a few
distinct advantages I will go into here.

Argo comes with a couple of great stuff. It is very well documented, and what I find especially pleasing is that the way
it operates does not require deep Kubernetes knowledge _by the entire team_. Instead, some people can focus on getting
Argo up and running (me, maybe one other cloud engineer), while others can simply focus on processing data (rest of the
team).

Argo makes that a reality. Simply by having a friendly GUI, workflow and event archives and associated logs stored into
something more palatable than some solution where you have to wade through tons of logs of _everything_ that ever
happened in your cluster. As you probably have seen, a lot happens in a cluster. The Argo archive and logs (if you
enabled them) allow you to retrieve and inspect the results of past workflows very quickly. It does not require you to
learn a DSL to filter in Kubernetes logs. You simply see the main status of completed workflow, click on one that has
failed and quickly triage the error.

Kubernetes operators should work the same. None of the operators I have seen so far allow you to quickly and efficiently
inspect errors, as quickly and efficiently as Argo allows you to do with workflows and events.

# Operator frameworks

## Ansible operators

The operators operated fine, but with a few minor inconveniences. At first, the SDK lagged a bit regarding runtime
dependencies, so I [contributed](https://github.com/operator-framework/operator-sdk/pull/4417)
a [few](https://github.com/operator-framework/operator-sdk/pull/4494) 
[pull](https://github.com/operator-framework/operator-sdk/pull/4529) 
[requests](https://github.com/operator-framework/operator-sdk/pull/4543)
in order to maintain the SDK. The thing was, however, that not only the SDK, but Ansible itself comes with an enormous
set of dependencies, each with their own issues and vulnerabilities. Also, it turned out that the Operators built with
the framework, consumed a rather large amount of memory and, because all operations go through Ansible and Python
runtimes, the operator is very slow.

Something else was getting a little funky as well. The operator I was maintaining had quite a bit of logic to follow up
on. I learned quickly that, if you need to manage a lot of logic, Ansible isn't a very good fit. It definitely can
handle _some_ logic, but it is quite verbose in that respect so things get out of hand if you need to implement and
check a lot of if/then/else statements. So I wrote
a ["custom Ansible module"](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html), which is
written in Python, but comes with its own complexity to integrate back into Ansible. 

The third thing I was missing, was manageable tests. Although it is certainly possible to functional test you Ansible
operator logic using [Molecule](https://molecule.readthedocs.io/en/latest/index.html), it is quite a hassle to set up,
and hard to maintain.

So, what I actually wanted was a Python Operator, but at the time an easy to use framework for this was not production
ready.


## Operators in Go

So, I started looking into operators made in Go directly, but I gave up quickly on that idea. Learning a new programming
language to serve only a single project probably isn't such a great idea, especially if you want to produce 
prduction-grade applications. You stick with what you know and trust best. I think it's probably a good idea to write
operators in Go, but it isn't my cup of tea. I followed a few tutorials and was rather taken aback by the complexity as
well. I was probably looking in the wrong place, but the amount of `// +kubebuilder:` logic 
[hidden in comments](https://sdk.operatorframework.io/docs/building-operators/golang/tutorial/#specify-permissions-and-generate-rbac-manifests) 
definitely felt like a code smell.

## Operators in Python
If I was writing my main logic in Python in the first place, maybe I should have gone with a Python operator SDK. 
Fortunately, the [Kopf framework](https://github.com/nolar/kopf) is there to help you. I haven't used it myself, but it
looks very nice, but also, looking at the code base, a very large and complex framework.

## Operators in Rust

I did check out writing an operator in Rust for a moment, using a 
[rather experimental-phase example](https://github.com/Pscheidl/rust-kubernetes-operator-example) template project. The
reason I think Rust is a perfect fit as a language to write Kubernetes operators in, is because it has such a sturdy 
feel to it. Any kind of runtime error is a nuisance in writing operators or cloud infrastructure components in general,
and Rust has such a great way of getting your programs stable. Also, I have a keen interest in Rust, much more so than
in Go, so it pays to learn the language and use it for building Kubernetes operators.

The largest downside to this approach was that my colleagues weren't much interested in getting into Rust as much as I
am. So I let go of the idea. Plus: the development state of Rust Kubernetes operator frameworks was still in its infancy
at the time of writing this up. But much of anything in the Kubernetes operator business is still in its infancy anyway.

In all, I think it would be an excellent idea to pursue the development of Kubernetes operators in Rust.

# And now for something completely different



So, I started to follow up on this.
