import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

import org.jenkinsci.plugins.simpletheme.ThemeElement
import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement
import org.jenkinsci.plugins.simpletheme.CssTextThemeElement

def jenkins = Jenkins.instance
def jenkinsUrl = JenkinsLocationConfiguration.get().url

def desc = jenkins.getDescriptor("org.codefirst.SimpleThemeDecorator")
desc.elements.clear()

// Branding
def cssOverrides = new CssTextThemeElement("""\
img#jenkins-head-icon {
    content:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAMAAAAOusbgAAAAq1BMVEUASn3///84cJhYiKjI2OCgwNAQWIhAeKCwyNgIUID4+PiwwNjw+Pjw8Pjo8PCguNAgYJAQUIAASIAAUICowNDg6PDY4OjA0OCQsMiIqMDQ4OiYuMh4oLhwmLhQgKgoaJC40Ni4yNiYuNBokLBgiKgwcJgoYJD4//+AqMAgYIgYYIgYWIjQ2OiwwNCAoMBomLBQgKBIgKD4+P+40OCYsMiQsMBwmLBgkLAwaJAxmxMZAAACN0lEQVR4Ae3XBZLcMBCF4fcGDBpmomXG8P1PlvSSXCNrqxzLwf4u8BuEUP8+pZRSSiml1EFHnOKXa1DU/vGwhjWsYQ1rWMMa1rCGr2NxBivtDxBEdHJxlDQ+NhfH/ZxwnaL50ozn0zYZh6huZrSWi7N3wlefOhQBwuldm3t6l55wtDBkoHC9S5e5GOaFa10yUHj0mfkOIjd8bBgqHB3QZzKx4ROKNq329BQlpHZQLS+2tf7pw2Z2TisbtsztSYRyjvii18erKDvW7Ke2mn2UteGzxg5Z12N/mN0YpV0ZPhmn2LP2hpd9lNfjkx5cx55w9xLl7fhkliLHPDdsaghgRWHy32E0zQvPEcCwS7FAvoeccDtCADUKM4DH0g3PEcKCIoHP2g3HCCGh+AqfnRNujwIeME7hM/ywH14iiAnFFbwm++FDBGEoRvC6cffjjHS1Our17lFcl+L6/Tf2hyOKFoqxL/QNXqaicEJRh0+fFYXnFGP4fKkq/EjRSeExqyqctik2yFdjVWGMKToDzwv7wsPxbStJkkOKbvLkGEXEdN7Duqc3TNeq8LgWa7ji8yrDO/rKj20WCh/9xIwS4wGyRmuyWLiHYkYzPutuUrzZTll1GNFbo9PcnqVI+/F8QvrDInrSp0gGP6TpCEX1p8wwzGh3A87jAre26a5RaRijxTlzJINhpWFxNua+Rgyg4rCo9Tq0zOEWCB72GMWLpDEx3eXhapsCbtiZNAOKMZRSSimllFJKqb/Dd+OYH9nM23l7AAAAAElFTkSuQmCC);
}

#header {
    background-image: repeating-linear-gradient(0deg, rgba(0, 0, 0, 0.11) 0px, rgba(0, 0, 0, 0.11) 12px, rgba(1, 1, 1, 0.16) 12px, rgba(1, 1, 1, 0.16) 24px, rgba(0, 0, 0, 0.14) 24px, rgba(0, 0, 0, 0.14) 36px, rgba(0, 0, 0, 0.23) 36px, rgba(0, 0, 0, 0.23) 48px, rgba(0, 0, 0, 0.12) 48px, rgba(0, 0, 0, 0.12) 60px, rgba(1, 1, 1, 0.07) 60px, rgba(1, 1, 1, 0.07) 72px, rgba(0, 0, 0, 0.21) 72px, rgba(0, 0, 0, 0.21) 84px, rgba(0, 0, 0, 0.24) 84px, rgba(0, 0, 0, 0.24) 96px, rgba(1, 1, 1, 0.23) 96px, rgba(1, 1, 1, 0.23) 108px, rgba(1, 1, 1, 0.07) 108px, rgba(1, 1, 1, 0.07) 120px, rgba(0, 0, 0, 0.01) 120px, rgba(0, 0, 0, 0.01) 132px, rgba(1, 1, 1, 0.22) 132px, rgba(1, 1, 1, 0.22) 144px, rgba(1, 1, 1, 0.24) 144px, rgba(1, 1, 1, 0.24) 156px, rgba(0, 0, 0, 0) 156px, rgba(0, 0, 0, 0) 168px, rgba(0, 0, 0, 0.12) 168px, rgba(0, 0, 0, 0.12) 180px), repeating-linear-gradient(90deg, rgba(1, 1, 1, 0.01) 0px, rgba(1, 1, 1, 0.01) 12px, rgba(1, 1, 1, 0.15) 12px, rgba(1, 1, 1, 0.15) 24px, rgba(0, 0, 0, 0.09) 24px, rgba(0, 0, 0, 0.09) 36px, rgba(0, 0, 0, 0.02) 36px, rgba(0, 0, 0, 0.02) 48px, rgba(0, 0, 0, 0.1) 48px, rgba(0, 0, 0, 0.1) 60px, rgba(1, 1, 1, 0.07) 60px, rgba(1, 1, 1, 0.07) 72px, rgba(1, 1, 1, 0.15) 72px, rgba(1, 1, 1, 0.15) 84px, rgba(0, 0, 0, 0.18) 84px, rgba(0, 0, 0, 0.18) 96px, rgba(1, 1, 1, 0.15) 96px, rgba(1, 1, 1, 0.15) 108px, rgba(1, 1, 1, 0.09) 108px, rgba(1, 1, 1, 0.09) 120px, rgba(1, 1, 1, 0.07) 120px, rgba(1, 1, 1, 0.07) 132px, rgba(1, 1, 1, 0.05) 132px, rgba(1, 1, 1, 0.05) 144px, rgba(0, 0, 0, 0.1) 144px, rgba(0, 0, 0, 0.1) 156px, rgba(1, 1, 1, 0.18) 156px, rgba(1, 1, 1, 0.18) 168px), repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.24) 0px, rgba(0, 0, 0, 0.24) 16px, rgba(1, 1, 1, 0.06) 16px, rgba(1, 1, 1, 0.06) 32px, rgba(0, 0, 0, 0.16) 32px, rgba(0, 0, 0, 0.16) 48px, rgba(1, 1, 1, 0) 48px, rgba(1, 1, 1, 0) 64px, rgba(1, 1, 1, 0.12) 64px, rgba(1, 1, 1, 0.12) 80px, rgba(1, 1, 1, 0.22) 80px, rgba(1, 1, 1, 0.22) 96px, rgba(0, 0, 0, 0.24) 96px, rgba(0, 0, 0, 0.24) 112px, rgba(0, 0, 0, 0.25) 112px, rgba(0, 0, 0, 0.25) 128px, rgba(1, 1, 1, 0.12) 128px, rgba(1, 1, 1, 0.12) 144px, rgba(0, 0, 0, 0.18) 144px, rgba(0, 0, 0, 0.18) 160px, rgba(1, 1, 1, 0.03) 160px, rgba(1, 1, 1, 0.03) 176px, rgba(1, 1, 1, 0.1) 176px, rgba(1, 1, 1, 0.1) 192px), repeating-linear-gradient(135deg, rgba(1, 1, 1, 0.18) 0px, rgba(1, 1, 1, 0.18) 3px, rgba(0, 0, 0, 0.09) 3px, rgba(0, 0, 0, 0.09) 6px, rgba(0, 0, 0, 0.08) 6px, rgba(0, 0, 0, 0.08) 9px, rgba(1, 1, 1, 0.05) 9px, rgba(1, 1, 1, 0.05) 12px, rgba(0, 0, 0, 0.01) 12px, rgba(0, 0, 0, 0.01) 15px, rgba(1, 1, 1, 0.12) 15px, rgba(1, 1, 1, 0.12) 18px, rgba(0, 0, 0, 0.05) 18px, rgba(0, 0, 0, 0.05) 21px, rgba(1, 1, 1, 0.16) 21px, rgba(1, 1, 1, 0.16) 24px, rgba(1, 1, 1, 0.07) 24px, rgba(1, 1, 1, 0.07) 27px, rgba(1, 1, 1, 0.23) 27px, rgba(1, 1, 1, 0.23) 30px, rgba(0, 0, 0, 0.2) 30px, rgba(0, 0, 0, 0.2) 33px, rgba(0, 0, 0, 0.18) 33px, rgba(0, 0, 0, 0.18) 36px, rgba(1, 1, 1, 0.12) 36px, rgba(1, 1, 1, 0.12) 39px, rgba(1, 1, 1, 0.13) 39px, rgba(1, 1, 1, 0.13) 42px, rgba(1, 1, 1, 0.2) 42px, rgba(1, 1, 1, 0.2) 45px, rgba(1, 1, 1, 0.18) 45px, rgba(1, 1, 1, 0.18) 48px, rgba(0, 0, 0, 0.2) 48px, rgba(0, 0, 0, 0.2) 51px, rgba(1, 1, 1, 0) 51px, rgba(1, 1, 1, 0) 54px, rgba(0, 0, 0, 0.03) 54px, rgba(0, 0, 0, 0.03) 57px, rgba(1, 1, 1, 0.06) 57px, rgba(1, 1, 1, 0.06) 60px, rgba(1, 1, 1, 0) 60px, rgba(1, 1, 1, 0) 63px, rgba(0, 0, 0, 0.1) 63px, rgba(0, 0, 0, 0.1) 66px, rgba(1, 1, 1, 0.19) 66px, rgba(1, 1, 1, 0.19) 69px), linear-gradient(90deg, rgb(0,74,124), rgb(0,74,124));
    border-bottom: #f0ad4e 3px solid;
}
""")

List<ThemeElement> settings = new ArrayList<>();
settings.add(cssOverrides)

desc.elements = settings
desc.save()
