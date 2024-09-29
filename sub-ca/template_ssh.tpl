{{ $supported := dict
    "*ssh.rsaPublicKey"         true
    "*ssh.dsaPublicKey"         false
    "*ssh.ecdsaPublicKey"       false
    "*ssh.skECDSAPublicKey"     false
    "ssh.ed25519PublicKey"      true
    "*ssh.skEd25519PublicKey"   true
}}
{{- if not (get $supported (typeOf .Insecure.CR.Key)) }}
{{ print "Unsupported key type " (typeOf .Insecure.CR.Key) | fail }}
{{- end }}
{
    "type": {{ toJson .Type }},
    "keyId": {{ toJson .KeyID }},
    "principals": {{ toJson .Principals }},
    "extensions": {{ toJson .Extensions }},
    "criticalOptions": {{ toJson .CriticalOptions }}
}