import jenkins.model.Jenkins

import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement
import org.jenkinsci.plugins.simpletheme.CssTextThemeElement

def jenkins = Jenkins.instance

def desc = jenkins.getDescriptor("org.codefirst.SimpleThemeDecorator")
desc.elements.clear()

// https://tobix.github.io/jenkins-neo2-theme/dist/neo-light.css
// at /var/jenkins_home/custom-css/neo-light.css
def cssNeoLight = new CssTextThemeElement(new File(jenkins.rootDir, 'custom-css/neo-light.css').text)
desc.elements.add(cssNeoLight)

def cssOverrides = new CssTextThemeElement('''\
#header {
    background-color: #0087f6;
}

#breadcrumbBar, #footer-container, .top-sticker-inner {
    background-color: #f1f1f1 !important;
}

.pane-frame .pane-header {
    border-bottom: 2px solid #3477b4;
}

#header #search-box {
    color: #26262d;
    padding-left: 20px;
    background: white url(../images/16x16/search.png) no-repeat 2px center;
}
''')
desc.elements.add(cssOverrides)

desc.save()
