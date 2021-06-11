#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'


@test "Pull latest tag by default" {
    export BUILDKITE_PLUGIN_ECR_PULL_REPOSITORY="app/repo"
    stub curl \
            '-s http://169.254.169.254/latest/meta-data/placement/availability-zone : echo az eu-central-1a'

    stub aws \
            "sts get-caller-identity --output text : echo '123456789012	arn:aws:iam::123456789012/user/role	ABCDEFGHIJKLMNOPQRSTU'"  \
            "ecr describe-repositories --region eu-central-1 --repository-names app/repo --registry-id 123456789012 --output text --query 'repositories[0].repositoryUri' : echo docker.repo.test/app/repo"

    stub docker \
            'pull docker.repo.test/app/repo:latest : echo "image pulled"'

    run "$PWD/hooks/command"

    assert_success
    assert_output --partial "--- Ready to pull images"
    assert_output --partial "Repository: docker.repo.test/app/repo"
    assert_output --partial "Tags: latest"
    assert_output --partial "Pulling: docker.repo.test/app/repo:latest"

    unstub curl
    unstub aws
    unstub docker
}

@test "Pull multiple tags" {
    export BUILDKITE_PLUGIN_ECR_PULL_REPOSITORY="app/repo"
    export BUILDKITE_PLUGIN_ECR_PULL_TAGS_0="one"
    export BUILDKITE_PLUGIN_ECR_PULL_TAGS_1="two"
    export BUILDKITE_PLUGIN_ECR_PULL_TAGS_2="three"

    stub curl \
            '-s http://169.254.169.254/latest/meta-data/placement/availability-zone : echo az eu-central-1a'

    stub aws \
            "sts get-caller-identity --output text : echo '123456789012	arn:aws:iam::123456789012/user/role	ABCDEFGHIJKLMNOPQRSTU'"  \
            "ecr describe-repositories --region eu-central-1 --repository-names app/repo --registry-id 123456789012 --output text --query 'repositories[0].repositoryUri' : echo docker.repo.test/app/repo"

    stub docker \
            'pull docker.repo.test/app/repo:one : echo "image one pulled"' \
            'pull docker.repo.test/app/repo:two : echo "image two pulled"' \
            'pull docker.repo.test/app/repo:three : echo "image three pulled"'

    run "$PWD/hooks/command"

    assert_success
    assert_output --partial "--- Ready to pull images"
    assert_output --partial "Repository: docker.repo.test/app/repo"
    assert_output --partial "Tags: one two three"
    assert_output --partial "Pulling: docker.repo.test/app/repo:one"
    assert_output --partial "Pulling: docker.repo.test/app/repo:two"
    assert_output --partial "Pulling: docker.repo.test/app/repo:three"

    unstub curl
    unstub aws
    unstub docker
}
