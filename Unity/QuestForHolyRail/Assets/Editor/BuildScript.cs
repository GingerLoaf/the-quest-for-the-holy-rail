using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEditor.Build.Reporting;

public class BuildScript
{
    private static string GetGitCommitSHA()
    {
        // Try GitHub Actions environment variables first (more reliable in CI/CD)
        string githubSHA = Environment.GetEnvironmentVariable("GITHUB_SHA");
        if (!string.IsNullOrEmpty(githubSHA))
        {
            // Use short SHA (first 7 chars) to match git rev-parse --short
            string shortSHA = githubSHA.Substring(0, Math.Min(7, githubSHA.Length));
            Debug.Log($"Using GitHub Actions SHA: {shortSHA}");
            return shortSHA;
        }

        string githubRunNumber = Environment.GetEnvironmentVariable("GITHUB_RUN_NUMBER");
        if (!string.IsNullOrEmpty(githubRunNumber))
        {
            Debug.Log($"Using GitHub Actions run number: {githubRunNumber}");
            return $"build-{githubRunNumber}";
        }

        // Fall back to git command (works locally)
        try
        {
            ProcessStartInfo startInfo = new ProcessStartInfo
            {
                FileName = "git",
                Arguments = "rev-parse --short HEAD",
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true,
                WorkingDirectory = Directory.GetParent(Application.dataPath)?.FullName ?? "."
            };

            using (Process process = Process.Start(startInfo))
            {
                if (process == null)
                {
                    Debug.LogWarning("Failed to start git process");
                    return "unknown";
                }

                string output = process.StandardOutput.ReadToEnd().Trim();
                string error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                if (process.ExitCode == 0 && !string.IsNullOrEmpty(output))
                {
                    Debug.Log($"Git commit SHA: {output}");
                    return output;
                }
                else
                {
                    Debug.LogWarning($"Failed to get git commit SHA: {error}");
                    return "unknown";
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogWarning($"Error getting git commit SHA: {e.Message}");
            return "unknown";
        }
    }

    private static string[] GetScenePaths()
    {
        return EditorBuildSettings.scenes
            .Where(scene => scene.enabled)
            .Select(scene => scene.path)
            .ToArray();
    }

    private static void PerformBuild(BuildTarget target, string platform)
    {
        string commitSHA = GetGitCommitSHA();
        string buildFolder = Path.Combine("Builds", $"{platform}_{commitSHA}");
        
        // Sanitize product name for safe filename usage
        string productName = PlayerSettings.productName ?? "Game";
        foreach (var c in Path.GetInvalidFileNameChars())
            productName = productName.Replace(c, '_');
        productName = productName.Replace(' ', '_');
        
        // Determine the build path based on platform
        // Use stable artifact names (required for itch.io, Steam, etc.)
        string buildPath;
        if (target == BuildTarget.StandaloneWindows64)
        {
            buildPath = Path.Combine(buildFolder, $"{productName}.exe");
        }
        else if (target == BuildTarget.StandaloneOSX)
        {
            buildPath = Path.Combine(buildFolder, $"{productName}.app");
        }
        else
        {
            buildPath = Path.Combine(buildFolder, productName);
        }

        // Create the build folder if it doesn't exist
        Directory.CreateDirectory(buildFolder);

        // log the build path
        Debug.Log($"Build folder (absolute): {Path.GetFullPath(buildFolder)}");
        Debug.Log($"Build output (absolute): {Path.GetFullPath(buildPath)}");
        
        Debug.Log($"Building {platform} to: {buildPath}");
        Debug.Log($"Commit SHA: {commitSHA}");

        string[] scenes = GetScenePaths();
        if (scenes.Length == 0)
        {
            Debug.LogError("No scenes found in build settings!");
            EditorApplication.Exit(1);
            return;
        }

        Debug.Log($"Including {scenes.Length} scene(s): {string.Join(", ", scenes)}");

        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = scenes,
            locationPathName = buildPath,
            target = target,
            options = BuildOptions.None
        };

        Debug.Log($"Starting build for {platform}...");
        BuildReport report = BuildPipeline.BuildPlayer(buildPlayerOptions);
        BuildSummary summary = report.summary;

        if (summary.result == BuildResult.Succeeded)
        {
            Debug.Log($"Build succeeded: {buildPath}");
            Debug.Log($"Build size: {summary.totalSize} bytes");
            Debug.Log($"Build time: {summary.totalTime}");
            EditorApplication.Exit(0);
        }
        else
        {
            Debug.LogError($"Build failed with result: {summary.result}");
            EditorApplication.Exit(1);
        }
    }

    [MenuItem("Build/Build Windows")]
    public static void BuildWindows()
    {
        Debug.Log("=== Starting Windows Build ===");
        PerformBuild(BuildTarget.StandaloneWindows64, "Windows");
    }

    [MenuItem("Build/Build macOS")]
    public static void BuildMacOS()
    {
        Debug.Log("=== Starting macOS Build ===");
        PerformBuild(BuildTarget.StandaloneOSX, "macOS");
    }
}
