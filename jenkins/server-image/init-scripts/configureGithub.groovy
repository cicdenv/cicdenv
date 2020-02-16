import jenkins.model.Jenkins

import net.sf.json.JSONObject
import org.jenkinsci.plugins.github.config.GitHubPluginConfig
import org.jenkinsci.plugins.github.config.GitHubServerConfig
import org.jenkinsci.plugins.github.config.HookSecretConfig

boolean isServerConfigsEqual(List s1, List s2) {
    s1.size() == s2.size() && !(
        false in [s1, s2].transpose().collect { c1, c2 ->
            c1.name == c2.name &&
            c1.apiUrl == c2.apiUrl &&
            c1.manageHooks == c2.manageHooks &&
            c1.credentialsId == c2.credentialsId &&
            c1.clientCacheSize == c2.clientCacheSize
        }
    )
}

boolean isOverrideHookEqual(def globalSettings, JSONObject githubPlugin) {
    (
        (
            globalSettings.isOverrideHookURL() &&
            githubPlugin.optString('overrideHookUrl') &&
            globalSettings.@hookUrl == new URL(githubPlugin.optString('overrideHookUrl'))
        ) || (
            !globalSettings.isOverrideHookURL() &&
            !githubPlugin.optString('overrideHookUrl')
        )
    )
}

boolean isGlobalSettingsEqual(def globalSettings, JSONObject githubPlugin) {
    globalSettings.hookSecretConfig \
    && globalSettings.hookSecretConfig.credentialsId == githubPlugin.optString('hookSharedSecretId') \
    && isOverrideHookEqual(globalSettings, githubPlugin)
}

githubPlugin = [
    overrideHookUrl: /*'http://localhost:8080/github-webhook/'*/ null,
    hookSharedSecretId: null,
    servers: [
        'Public GitHub.com': [
            credentialsId: 'github-manage-webhooks-token',
        ]
    ]
] as JSONObject

List configs = []
githubPlugin.optJSONObject('servers').each { name, config ->
    if (name && config && config in Map) {
        def server = new GitHubServerConfig(config.optString('credentialsId'))
        server.name = name
        server.apiUrl = config.optString('apiUrl', GitHubServerConfig.GITHUB_URL)
        server.manageHooks = config.optBoolean('manageHooks', true)
        server.clientCacheSize = config.optInt('clientCacheSize', 20)
        configs << server
    }
}

def globalSettings = Jenkins.instance.getExtensionList(GitHubPluginConfig.class)[0]

if (githubPlugin && (!isGlobalSettingsEqual(globalSettings, githubPlugin) || !isServerConfigsEqual(globalSettings.configs, configs))) {
    if (globalSettings.hookSecretConfig && globalSettings.hookSecretConfig.credentialsId != githubPlugin.optString('hookSharedSecretId')) {
        globalSettings.hookSecretConfig = new HookSecretConfig(githubPlugin.optString('hookSharedSecretId'))
    }
    
    if (!isOverrideHookEqual(globalSettings, githubPlugin)) {
        if (globalSettings.isOverrideHookURL() && !githubPlugin.optString('overrideHookUrl')) {
            globalSettings.hookUrl = null
        } else if (globalSettings.@hookUrl != new URL(githubPlugin.optString('overrideHookUrl'))) {
            globalSettings.hookUrl = new URL(githubPlugin.optString('overrideHookUrl'))
        }
    }

    if (!isServerConfigsEqual(globalSettings.configs, configs)) {
        globalSettings.configs = configs
    }
    globalSettings.save()

    println 'Configured GitHub plugin.'
}
