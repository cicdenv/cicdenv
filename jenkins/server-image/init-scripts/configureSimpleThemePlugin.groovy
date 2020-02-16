import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement
import org.jenkinsci.plugins.simpletheme.CssTextThemeElement

def jenkinsUrl = JenkinsLocationConfiguration.get().url

def desc = Jenkins.instance.getDescriptor("org.codefirst.SimpleThemeDecorator")

def cssUrl = new CssUrlThemeElement("${jenkinsUrl}userContent/neo-light.css")
desc.elements.add(cssUrl)

def cssText = new CssTextThemeElement('''\
#header {
    background-color: #170f47;
}

#breadcrumbBar, #footer-container, .top-sticker-inner {
    background-color: #f1f1f1 !important;
}

.pane-frame .pane-header {
    border-bottom: 2px solid #ff501a;
}

#header #search-box {
    color: #26262d;
    padding-left: 20px;
    background: white url(../images/16x16/search.png) no-repeat 2px center;
}
''')
desc.elements.add(cssText)

desc.save()
