import * as pulumi from "@pulumi/pulumi";
import * as digitalocean from "@pulumi/digitalocean";

// Create a DigitalOcean resource (Domain)
const domain = new digitalocean.Domain("joshisa.ninja", {
  name: "joshisa.ninja"
}, { import: "joshisa.ninja" });

const apexGhPage1Record = new digitalocean.DnsRecord("gh-pages1", {
  name: "@",
  domain: domain.name,
  type: "A",
  value: "185.199.108.153",
  ttl: 120
});

const apexGhPage2Record = new digitalocean.DnsRecord("gh-pages2", {
  name: "@",
  domain: domain.name,
  type: "A",
  value: "185.199.109.153",
  ttl: 120
});

const apexGhPage3Record = new digitalocean.DnsRecord("gh-pages3", {
  name: "@",
  domain: domain.name,
  type: "A",
  value: "185.199.110.153",
  ttl: 120
});

const apexGhPage4Record = new digitalocean.DnsRecord("gh-pages4", {
  name: "@",
  domain: domain.name,
  type: "A",
  value: "185.199.111.153",
  ttl: 120
});

const apexGhPageWwwRecord = new digitalocean.DnsRecord("gh-pages-www", {
  name: "www",
  domain: domain.name,
  type: "CNAME",
  value: "joshashby.github.io.",
  ttl: 120
});

const ns1Record = new digitalocean.DnsRecord("ns1.@", {
  name: "@",
  domain: domain.name,
  type: "NS",
  value: "ns1.digitalocean.com.",
  ttl: 1800
}, { import: "joshisa.ninja,56550425" });

const ns2Record = new digitalocean.DnsRecord("ns2.@", {
  name: "@",
  domain: domain.name,
  type: "NS",
  value: "ns2.digitalocean.com.",
  ttl: 1800
}, { import: "joshisa.ninja,56550426" });

const ns3Record = new digitalocean.DnsRecord("ns3.@", {
  name: "@",
  domain: domain.name,
  type: "NS",
  value: "ns3.digitalocean.com.",
  ttl: 1800
}, { import: "joshisa.ninja,56550427" });

// Export the name of the domain
export const domainName = domain.name;
