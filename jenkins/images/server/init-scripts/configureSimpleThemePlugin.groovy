import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

import org.jenkinsci.plugins.simpletheme.ThemeElement
import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement
import org.jenkinsci.plugins.simpletheme.CssTextThemeElement

def jenkins = Jenkins.instance
def jenkinsUrl = JenkinsLocationConfiguration.get().url

def desc = jenkins.getDescriptor("org.codefirst.SimpleThemeDecorator")
desc.elements.clear()

// https://tobix.github.io/jenkins-neo2-theme/dist/neo-light.css
// at /var/jenkins_home/custom-css/neo-light.css
def cssBase = new CssTextThemeElement(new File(jenkins.rootDir, 'custom-css/neo-light.css').text)
def cssOverrides = new CssTextThemeElement("""\
img#jenkins-head-icon {
    content:url("${jenkinsUrl}userContent/socotra-logo-square.png");
}

#header {
    background-color: #414141;
    border-bottom: #73726f 3px solid;
}

.pane-frame .pane-header {
    border-bottom: 2px solid #73726f;
}

#header #search-box {
    background: white;
}
""")

List<ThemeElement> settings = new ArrayList<>();
settings.add(cssBase)
settings.add(cssOverrides)

desc.elements = settings
desc.save()
