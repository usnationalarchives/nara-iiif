import Mirador from 'mirador';

class Viewer {
  constructor(config) {
    const self = this;
    self.el = config.el;

    const manifestUri = this.el.getAttribute('manifest-url');

    const viewer = Mirador.viewer({
      id: 'viewer',
      workspaceControlPanel: {
        enabled: false
      },
      windows: [
        {
          manifestId: manifestUri,
          thumbnailNavigationPosition: 'far-right'
        }
      ],
      manifests: {
        manifestUri: { provider: 'NARA' }
      },
      window: {
        allowClose: false,
        sideBarOpenByDefault: false
      },
      workspace: {
        showZoomControls: true,
        type: 'mosaic'
      }
    });
  }
}

const viewers = document.querySelectorAll('.viewer');

[].forEach.call(viewers, viewer => {
  new Viewer({ el: viewer });
});
