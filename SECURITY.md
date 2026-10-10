# Security policy

## Supported scope

| Version | Scope |
| --- | --- |
| v1.0.x | Maintainer triage for the verification scaffold and build/proof workflow |
| Unreleased runtime designs | Design review; no supported deployed interpreter |

The repository is private. v1 contains interfaces, a proof/control model, and an
allocation counter. It is not a sandbox for executing untrusted Unlambda code.
Passing typechecks and the counter's SPARK proofs do not establish security of
an interpreter, an FFI adapter, or a production deployment.

## Report privately

Email the repository owner at **ahmedparr93@gmail.com** with subject
`[unlambda-idris-spark] Security report`. This is the contact published on the
[maintainer's GitHub profile](https://github.com/AHMADALIPARR). If GitHub private
vulnerability reporting is enabled later, the repository's Security tab may
also provide a private report form. Do not assume that form is currently enabled.

Include the affected commit/version, relevant toolchain versions, a minimal
reproduction, expected impact, and suggested remediation if available. Do not
include credentials, personal data, or live customer input. Avoid publishing
an exploit or opening an ordinary issue containing sensitive details while
the report is being investigated.

The maintainer reviews reports and coordinates fixes and disclosure. No fixed
response SLA or paid bounty program is currently promised.

## What to report

- Build or agent-hook execution that can expose secrets or run unintended commands.
- A proof gate that reports success despite missing, suppressed, or unproved checks.
- Unsafe future handle lookup, generation reuse, or incorrect memory exhaustion.
- Release asset/source mismatch, compromised dependencies, or false evidence claims.
- A defect in the checked model or contracts that invalidates a documented result.

## Build and proof boundaries

CI actions and compiler sources are pinned; the GNATprove archive is checksum
verified. Evidence is tied to source commits. Credentials and local
`agent_hooks.sh` must not be committed. Generated proof modules require the same
review and typechecking as handwritten modules. Third-party compilers, provers,
and runtime libraries remain part of the trusted toolchain.
