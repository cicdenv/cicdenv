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
    background-color: #000000;
    border-bottom: #ef7150 3px solid;
    box-sizing: border-box;
    height: 50px;
}

#header .searchbox {
    padding: 5px 10px 0px 10px;
}

.top-sticker .noedge {
    top: 56px;
}
.pane-frame .pane-header {
    border-bottom: 2px solid #ef7150;
}

#header #search-box {
    color: #26262d;
    padding-left: 32px;
    background: white;
}
''')
desc.elements.add(cssOverrides)

desc.save()
