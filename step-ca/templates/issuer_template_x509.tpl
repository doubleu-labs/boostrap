{
    "subject": {{ toJson .Insecure.CR.Subject }},
    "sans": {{ toJson .SANs }},
    "crlDistributionPoints": {{ toJson .CDP }},
    "issuingCertificateURL": {{ toJson .AIA }},
    "keyUsage": [
        {{- if typeIs "*rsa.PublicKey" .Insecure.CR.PublicKey }}
        "keyEncipherment",
        {{- end }}
        "digitalSignature"
    ],
    "extKeyUsage": [
        "clientAuth",
        "serverAuth"
    ]
}