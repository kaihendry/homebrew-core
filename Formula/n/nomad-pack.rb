class NomadPack < Formula
  desc "Templating and packaging tool used with HashiCorp Nomad"
  homepage "https://github.com/hashicorp/nomad-pack"
  url "https://github.com/hashicorp/nomad-pack/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "4865cc1490d3aeb48248133ec667162cb1199e379d592643ef024b9ac0f30640"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/nomad-pack/internal/pkg/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/nomad-pack/internal/pkg/version.GitDescribe=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"metadata.hcl").write <<~HCL
      app {
        url = ""
      }
      pack {
        name        = "test"
        description = "Test"
        version     = "0.1.2"
      }
    HCL

    (testpath/"variables.hcl").write <<~HCL
      variable "cpu" {
        type    = number
        default = 500
      }
      variable "memory" {
        type    = number
        default = 256
      }
    HCL

    (testpath/"templates/test.nomad.tpl").write <<~HCL
      resources {
        cpu    = [[ var "cpu" . ]]
        memory = [[ var "memory" . ]]
      }
    HCL

    assert_match <<~HCL, shell_output("#{bin}/nomad-pack render .")
      resources {
        cpu    = 500
        memory = 256
      }
    HCL

    assert_match "Nomad Pack v#{version}", shell_output("#{bin}/nomad-pack version")
  end
end
